using System;
using System.Linq;
using System.Web.UI;
using WenYanHub.Models;
using WenYanHub.Admin.Utils;

namespace WenYanHub.Admin
{
    public partial class ViewTickets : System.Web.UI.Page
    {
        private int CurrentPage
        {
            get { return ViewState["CurrentPage"] != null ? (int)ViewState["CurrentPage"] : 0; }
            set { ViewState["CurrentPage"] = value; }
        }

        private const int PageSize = 10;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack) { BindTickets(""); }
        }

        protected void txtSearch_TextChanged(object sender, EventArgs e)
        {
            CurrentPage = 0;
            BindTickets(txtSearch.Text.Trim());
        }

        protected void btnPrevPage_Click(object sender, EventArgs e)
        {
            CurrentPage--;
            BindTickets(txtSearch.Text.Trim());
        }

        protected void btnNextPage_Click(object sender, EventArgs e)
        {
            CurrentPage++;
            BindTickets(txtSearch.Text.Trim());
        }

        // 🔥 NEW: Save Note without changing the status
        protected void btnSaveNote_Click(object sender, EventArgs e) => UpdateTicketData("Pending");

        protected void btnMarkSolved_Click(object sender, EventArgs e) => UpdateTicketData("Solved");
        protected void btnReject_Click(object sender, EventArgs e) => UpdateTicketData("Rejected");

        private void UpdateTicketData(string newStatus)
        {
            string trackingCode = hfSelectedTicket.Value;
            if (string.IsNullOrEmpty(trackingCode)) return;

            using (var db = new AppDbContext())
            {
                var ticket = db.Feedbacks.FirstOrDefault(f => f.TrackingCode == trackingCode);
                if (ticket != null)
                {
                    // Update the status (If btnSaveNote was clicked, it safely keeps it as Pending)
                    ticket.Status = newStatus;

                    // Save the text from the modal's input field
                    ticket.AdminReply = txtAdminReply.Text.Trim();

                    ticket.UpdatedAt = DateTime.Now;
                    db.SaveChanges();

                    int adminId = Convert.ToInt32(Session["UserId"] ?? 1);
                    SystemLogger.LogEvent(adminId, "Updated Support Ticket", "Support", $"{{ \"ticket_code\": \"{trackingCode}\", \"new_status\": \"{newStatus}\" }}");
                }
            }
            // Refresh to update the grid and tabs
            Response.Redirect(Request.RawUrl);
        }

        private void BindTickets(string searchTerm = "")
        {
            using (var db = new AppDbContext())
            {
                var query = db.Feedbacks.AsQueryable();

                if (!string.IsNullOrEmpty(searchTerm))
                {
                    query = query.Where(f => f.TrackingCode.Contains(searchTerm) || f.ContactEmail.Contains(searchTerm));
                }

                string viewType = Request.QueryString["view"] ?? "pending";
                string viewTypeSafe = viewType.ToLower();

                if (viewTypeSafe == "solved") query = query.Where(f => f.Status.ToLower() == "solved");
                else if (viewTypeSafe == "rejected") query = query.Where(f => f.Status.ToLower() == "rejected");
                else query = query.Where(f => f.Status == null || f.Status.ToLower() == "pending" || f.Status.ToLower() == "open");

                int totalRecords = query.Count();

                int totalPages = (totalRecords + PageSize - 1) / PageSize;
                if (totalPages == 0) totalPages = 1;

                if (CurrentPage >= totalPages) CurrentPage = totalPages - 1;
                if (CurrentPage < 0) CurrentPage = 0;

                var rawList = query.OrderByDescending(t => t.CreatedAt)
                                   .Skip(CurrentPage * PageSize)
                                   .Take(PageSize)
                                   .ToList();

                var mappedData = rawList.Select(t => {
                    double daysOld = (DateTime.Now - t.CreatedAt).TotalDays;
                    string statusLower = (t.Status ?? "pending").ToLower();
                    bool isUnresolved = statusLower == "pending" || statusLower == "open";

                    string rowUrgencyClass = (isUnresolved && daysOld > 2) ? "is-urgent" : "";

                    string statusBadgeClass = "badge-outline ";
                    if (statusLower == "solved") statusBadgeClass += "badge-outline-dark";
                    else if (statusLower == "rejected") statusBadgeClass += "badge-outline-red";
                    else if (isUnresolved)
                    {
                        statusBadgeClass += (daysOld > 2) ? "badge-outline-red" : "badge-outline-gold";
                    }

                    string messageSnippet = t.Message ?? "";
                    if (messageSnippet.Length > 40) messageSnippet = messageSnippet.Substring(0, 37) + "...";

                    return new
                    {
                        t.FeedbackId,
                        t.TrackingCode,
                        t.ContactEmail,
                        Category = t.Category ?? "General",
                        Message = t.Message,
                        MessageSnippet = messageSnippet,
                        // Safely pass the AdminReply to the front-end hidden input
                        AdminReply = t.AdminReply ?? "",
                        Status = isUnresolved ? "Pending" : char.ToUpper(statusLower[0]) + statusLower.Substring(1),
                        DateString = t.CreatedAt.ToString("MMM dd, yyyy HH:mm"),
                        UrgencyClass = rowUrgencyClass,
                        StatusBadgeClass = statusBadgeClass
                    };
                }).ToList();

                rptTickets.DataSource = mappedData;
                rptTickets.DataBind();
                phNoTickets.Visible = !mappedData.Any();

                litCurrentPage.Text = (CurrentPage + 1).ToString();
                litTotalPages.Text = totalPages.ToString();
                litTotalRecords.Text = totalRecords.ToString();

                btnPrevPage.Visible = CurrentPage > 0;
                btnNextPage.Visible = CurrentPage < (totalPages - 1);
            }
        }
    }
}