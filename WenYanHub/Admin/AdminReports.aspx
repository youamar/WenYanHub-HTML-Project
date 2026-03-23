<%@ Page Title="Reports & Analytics" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="AdminReports.aspx.cs" Inherits="WenYanHub.Admin.AdminReports" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

    <style>
        /* ==========================================
           0. ZERO BLUE & FOCUS OVERRIDES
           ========================================== */
        * { -webkit-tap-highlight-color: transparent; }
        .form-control:focus, .form-select:focus, .btn:focus, a:focus { 
            box-shadow: none !important; 
            outline: none !important; 
            border-color: var(--theme-gold) !important; 
        }
        ::selection { background-color: var(--theme-gold) !important; color: var(--bg-white) !important; }

        /* ==========================================
           1. STRICT PALETTE VARIABLES
           ========================================== */
        :root {
            --theme-beige: #E8E2D5;
            --theme-gold: #D4AF37;
            --theme-red: #8B0000;
            --neutral-dark: #212529; /* Strict Black/Grey Neutral */
            --bg-white: #FFFFFF;
        }

        .text-neutral { color: var(--neutral-dark) !important; }
        .text-gold { color: var(--theme-gold) !important; }
        .text-red { color: var(--theme-red) !important; }

        .font-classic { font-family: 'Noto Serif SC', serif; }
        .font-sans { font-family: 'Segoe UI', Tahoma, sans-serif; }

        /* PAGE CANVAS */
        .page-canvas { background-color: var(--theme-beige); border-radius: 24px; padding: 35px; margin: 20px; min-height: 75vh; }

        /* ==========================================
           2. ACTION BUTTONS & BADGES
           ========================================== */
        .btn-outline-dark-custom { 
            background: transparent !important; 
            color: var(--neutral-dark) !important; 
            border: 2px solid var(--neutral-dark) !important; 
            transition: 0.3s; font-weight: bold; border-radius: 50px; padding: 10px 24px; 
            text-decoration: none; display: inline-flex; align-items: center; justify-content: center;
        }
        .btn-outline-dark-custom:hover { border-color: var(--theme-gold) !important; color: var(--theme-gold) !important; transform: translateY(-2px); }
        
        .btn-outline-danger-custom { 
            background: transparent !important; 
            color: var(--theme-red) !important; 
            border: 2px solid var(--theme-red) !important; 
            transition: 0.3s; font-weight: bold; border-radius: 50px; padding: 10px 24px; 
            text-decoration: none; display: inline-flex; align-items: center; justify-content: center;
        }
        .btn-outline-danger-custom:hover { background: var(--theme-red) !important; color: var(--bg-white) !important; transform: translateY(-2px); }

        .badge-outline-dark { border: 2px solid var(--neutral-dark); color: var(--neutral-dark); background: transparent; font-weight: bold; }
        .badge-outline-red { border: 2px solid var(--theme-red); color: var(--theme-red); background: transparent; font-weight: bold; }
        .badge-outline-gold { border: 2px solid var(--theme-gold); color: var(--theme-gold); background: transparent; font-weight: bold; }

        /* ==========================================
           3. ELEGANT FILTER ROW
           ========================================== */
        .elegant-input {
            border: 2px solid var(--neutral-dark) !important;
            border-radius: 8px !important;
            padding: 10px 16px;
            background-color: var(--bg-white) !important;
            color: var(--neutral-dark) !important;
            font-weight: 700;
            transition: 0.2s;
            height: 45px;
            font-family: 'Segoe UI', Tahoma, sans-serif;
        }
        .elegant-input:focus { border-color: var(--theme-gold) !important; }
        .filter-label { font-size: 0.7rem; font-weight: 800; color: var(--neutral-dark); opacity: 0.6; text-transform: uppercase; margin-bottom: 8px; display: block; letter-spacing: 0.5px; }

        /* ==========================================
           4. TABS (Active Tab is FILLED Gold)
           ========================================== */
        .nav-tabs { border-bottom: none; gap: 20px; margin-bottom: 2.5rem !important; }
        .nav-tabs .nav-link { 
            color: var(--neutral-dark); opacity: 0.6;
            font-family: 'Noto Serif SC', serif; 
            font-weight: 700; border: 2px solid transparent; padding: 10px 25px; border-radius: 50px; font-size: 1.1rem; transition: 0.3s;
            background: transparent; display: flex; align-items: center; gap: 8px;
        }
        .nav-tabs .nav-link:hover { opacity: 1; color: var(--theme-gold); border-color: rgba(212, 175, 55, 0.3); }
        
        /* 🔥 THE FIX: Filled Active Tab 🔥 */
        .nav-tabs .nav-link.active { 
            opacity: 1;
            color: var(--bg-white) !important; 
            background: var(--theme-gold) !important; 
            border: 2px solid var(--theme-gold) !important;
            box-shadow: 0 4px 15px rgba(212, 175, 55, 0.3);
        }

        /* ==========================================
           5. BLACK CONTENT OUTLINES
           ========================================== */
        .outlined-card {
            background: var(--bg-white); 
            border: 2px solid var(--neutral-dark) !important; /* 🔥 Black Outline 🔥 */
            border-radius: 20px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.02);
        }

        .stat-card {
            background: var(--bg-white); 
            border: 2px solid var(--neutral-dark) !important; /* 🔥 Black Outline 🔥 */
            border-radius: 20px;
            padding: 25px; display: flex; align-items: center; gap: 20px; transition: all 0.3s ease; height: 100%;
        }
        .stat-card:hover { transform: translateY(-5px); box-shadow: 0 10px 25px rgba(0,0,0,0.05); border-color: var(--theme-gold) !important; }
        .stat-icon {
            width: 65px; height: 65px; border-radius: 50%; min-width: 65px;
            display: flex; justify-content: center; align-items: center; font-size: 2rem;
            background: transparent; border: 2px solid;
        }

        /* Leaderboard Table */
        .classical-table th { background-color: var(--bg-white); color: var(--neutral-dark); font-family: 'Noto Serif SC', serif; font-weight: 700; border-bottom: 2px solid var(--neutral-dark) !important; position: sticky; top: 0; z-index: 1; text-transform: uppercase; font-size: 0.8rem; letter-spacing: 1px; padding-bottom: 15px; }
        .classical-table td { border-bottom: 1px solid rgba(33, 37, 41, 0.15); vertical-align: middle; padding: 15px 10px; color: var(--neutral-dark); font-weight: 600; }
        .classical-table tr:hover { background-color: rgba(33, 37, 41, 0.03); }
        .hover-gold:hover { color: var(--theme-gold) !important; text-decoration: underline !important; }
        
        /* Log Container */
        .log-container { background-color: transparent; border: none; padding: 0; }
        .log-row-card {
            border: 2px solid var(--neutral-dark) !important; /* 🔥 Black Outline 🔥 */
            border-radius: 12px;
            background: var(--bg-white);
            transition: all 0.2s ease;
        }
        .log-row-card:hover { border-color: var(--theme-gold) !important; transform: translateY(-2px); box-shadow: 0 4px 12px rgba(0,0,0,0.05); }
        
        .custom-scroll::-webkit-scrollbar { width: 6px; height: 6px; }
        .custom-scroll::-webkit-scrollbar-thumb { background: rgba(33, 37, 41, 0.2); border-radius: 10px; }
        
        /* Utility for Tooltip Icons */
        .hint-icon { cursor: help; font-size: 1.1rem; opacity: 0.8; transition: 0.2s; }
        .hint-icon:hover { opacity: 1; transform: scale(1.1); }
        
        /* 🔥 THE FIX: Make tooltips wider and easier to read 🔥 */
        .tooltip-inner {
            max-width: 380px !important;
            width: 380px !important;
            padding: 15px !important;
            box-shadow: 0 10px 30px rgba(0,0,0,0.3);
            border: 1px solid var(--theme-gold);
            font-family: 'Segoe UI', Tahoma, sans-serif;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    
    <asp:HiddenField ID="hfActiveReportTab" runat="server" Value="analytics" />
    <asp:HiddenField ID="hfChartLabels" runat="server" ClientIDMode="Static" />
    <asp:HiddenField ID="hfChartData" runat="server" ClientIDMode="Static" />

    <div class="page-canvas d-flex flex-column flex-grow-1 mt-2">        
        
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h3 class="fw-bold m-0 text-neutral font-classic">
                    <i class="bi bi-bar-chart-fill text-gold me-2"></i> Reports & Analytics
                </h3>
                <p class="text-neutral opacity-75 small mt-1 mb-0 font-sans fw-bold">Monitor platform analytics and track detailed system events.</p>
            </div>
        </div>

        <ul class="nav nav-tabs" id="reportTabs" role="tablist">
            <li class="nav-item" role="presentation">
                <button class="nav-link" id="analytics-tab" data-bs-toggle="tab" data-bs-target="#analytics" type="button" role="tab" onclick="document.getElementById('<%= hfActiveReportTab.ClientID %>').value = 'analytics';">
                    <i class="bi bi-graph-up-arrow"></i> Platform Analytics
                </button>
            </li>
            <li class="nav-item" role="presentation">
                <button class="nav-link" id="logs-tab" data-bs-toggle="tab" data-bs-target="#logs" type="button" role="tab" onclick="document.getElementById('<%= hfActiveReportTab.ClientID %>').value = 'logs';">
                    <i class="bi bi-terminal"></i> System Logs
                </button>
            </li>
        </ul>

        <div class="tab-content flex-grow-1 d-flex flex-column" id="reportTabsContent">
            
            <div class="tab-pane fade flex-grow-1" id="analytics" role="tabpanel">
                <div class="row mb-5 align-items-stretch">
                    <div class="col-md-4">
                        <div class="stat-card shadow-sm" data-bs-toggle="tooltip" title="Total number of registered Students, Teachers, and Admins this month.">
                            <div class="stat-icon" style="color: var(--neutral-dark); border-color: var(--neutral-dark);"><i class="bi bi-people"></i></div>
                            <div>
                                <h3 class="fw-bold text-neutral mb-0 font-classic"><asp:Literal ID="litTotalUsers" runat="server">0</asp:Literal></h3>
                                <div class="text-neutral opacity-75 small text-uppercase fw-bold font-sans">Total Users</div>
                                <div class="text-gold small fw-bold mt-1 font-sans"><i class="bi bi-arrow-up-short"></i>Joined This Month</div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="stat-card shadow-sm" data-bs-toggle="tooltip" title="Total number of lessons, videos, and materials uploaded this month.">
                            <div class="stat-icon" style="color: var(--theme-gold); border-color: var(--theme-gold);"><i class="bi bi-journal-text"></i></div>
                            <div>
                                <h3 class="fw-bold text-neutral mb-0 font-classic"><asp:Literal ID="litContentThisMonth" runat="server">0</asp:Literal></h3>
                                <div class="text-neutral opacity-75 small text-uppercase fw-bold font-sans">New Content</div>
                                <div class="text-gold small fw-bold mt-1 font-sans"><i class="bi bi-calendar-event me-1"></i> Added This Month</div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="stat-card shadow-sm" data-bs-toggle="tooltip" title="Total number of user feedback and support tickets successfully resolved this month.">
                            <div class="stat-icon" style="color: var(--theme-red); border-color: var(--theme-red);"><i class="bi bi-check-circle"></i></div>
                            <div>
                                <h3 class="fw-bold text-neutral mb-0 font-classic"><asp:Literal ID="litResolvedTickets" runat="server">0</asp:Literal></h3>
                                <div class="text-neutral opacity-75 small text-uppercase fw-bold font-sans">Support Tickets</div>
                                <div class="text-red small fw-bold mt-1 font-sans"><i class="bi bi-check2-all me-1"></i> Successfully Resolved</div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="row mb-5">
                    <div class="col-12">
                        <div class="outlined-card p-5">
                            <div class="d-flex justify-content-between align-items-center mb-4">
                                <h4 class="fw-bold text-neutral font-classic mb-0 d-flex align-items-center">
                                    <i class="bi bi-bar-chart-steps text-gold me-2"></i> User Acquisition (<%= DateTime.Now.Year %>)
                                    <i class="bi bi-info-circle text-gold ms-3 hint-icon" data-bs-toggle="tooltip" data-bs-placement="right" title="Tracks the number of new account registrations over the selected time period."></i>
                                </h4>
                                <asp:DropDownList ID="ddlChartRange" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlChartRange_SelectedIndexChanged" CssClass="form-select elegant-input" Width="200px">
                                    <asp:ListItem Text="Current Year" Value="12"></asp:ListItem>
                                    <asp:ListItem Text="Last 6 Months" Value="6"></asp:ListItem>
                                    <asp:ListItem Text="Last 3 Months" Value="3"></asp:ListItem>
                                </asp:DropDownList>
                            </div>
                            
                            <div style="position: relative; height: 350px; width: 100%;">
                                <canvas id="userGrowthChart"></canvas>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="row flex-grow-1 pb-4">
                    <div class="col-md-6 mb-4 mb-md-0 d-flex flex-column">
                        <div class="outlined-card p-5 flex-grow-1 d-flex flex-column" style="min-height: 450px;">
                            <h4 class="fw-bold text-neutral font-classic mb-1 d-flex align-items-center">
                                <i class="bi bi-award text-gold me-2"></i> Most Active Teachers
                                <i class="bi bi-question-circle text-gold ms-3 hint-icon" data-bs-toggle="tooltip" data-bs-placement="right" title="Teachers are ranked by the total volume of approved educational notes they have contributed."></i>
                            </h4>
                            <p class="text-neutral opacity-50 small border-bottom pb-3 mb-4 font-sans">Ranked by the highest number of feedback notes provided to students.</p>
                            
                            <div class="table-responsive flex-grow-1 custom-scroll" style="max-height: 350px; overflow-y: auto; padding-right: 10px;">
                                <table class="table classical-table table-borderless mb-0 w-100 font-sans">
                                    <colgroup><col style="width: 15%;"><col style="width: 35%;"><col style="width: 25%;"><col style="width: 25%;"></colgroup>
                                    <thead>
                                        <tr>
                                            <th>Rank</th>
                                            <th>Teacher Name</th>
                                            <th class="text-center" title="Total notes written">Notes Created</th>
                                            <th class="text-end pe-3" title="Date of their last recorded note">Last Active</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <asp:Repeater ID="rptTopTeachers" runat="server">
                                            <ItemTemplate>
                                                <tr>
                                                    <td class="fw-bold text-neutral opacity-50 font-monospace">#<%# Container.ItemIndex + 1 %></td>
                                                    <td class="fw-bold"><a href='ManageUsers.aspx' class="text-neutral text-decoration-none hover-gold"><%# Eval("TeacherName") %></a></td>
                                                    <td class="text-center"><span class="badge badge-outline-dark rounded-pill px-3 py-1"><%# Eval("NotesCount") %> Notes</span></td>
                                                    <td class="text-end pe-3 text-neutral opacity-50 small fw-bold"><%# Eval("LastActive") %></td>
                                                </tr>
                                            </ItemTemplate>
                                        </asp:Repeater>
                                        <asp:PlaceHolder ID="phNoTeachers" runat="server" Visible="false">
                                            <tr><td colspan="4" class="text-center text-neutral opacity-50 py-5 font-classic">No teacher activity found yet.</td></tr>
                                        </asp:PlaceHolder>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>

                    <div class="col-md-6 d-flex flex-column">
                        <div class="outlined-card p-5 flex-grow-1 d-flex flex-column" style="min-height: 450px;">
                            <h4 class="fw-bold text-neutral font-classic mb-1 d-flex align-items-center">
                                <i class="bi bi-trophy text-gold me-2"></i> Top Performing Students
                                <i class="bi bi-question-circle text-gold ms-3 hint-icon" data-bs-toggle="tooltip" data-bs-placement="left" title="Students are ranked primarily by the number of quizzes taken, followed by their average percentage score."></i>
                            </h4>
                            <p class="text-neutral opacity-50 small border-bottom pb-3 mb-4 font-sans">Ranked by participation volume and average quiz scores.</p>
                            
                            <div class="table-responsive flex-grow-1 custom-scroll" style="max-height: 350px; overflow-y: auto; padding-right: 10px;">
                                <table class="table classical-table table-borderless mb-0 w-100 font-sans">
                                    <colgroup><col style="width: 15%;"><col style="width: 35%;"><col style="width: 30%;"><col style="width: 20%;"></colgroup>
                                    <thead>
                                        <tr>
                                            <th>Rank</th>
                                            <th>Student Name</th>
                                            <th class="text-center" title="Total quizzes completed">Quizzes Taken</th>
                                            <th class="text-end pe-3" title="Average score across all quizzes">Avg Score</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <asp:Repeater ID="rptTopStudents" runat="server">
                                            <ItemTemplate>
                                                <tr>
                                                    <td class="fw-bold text-neutral opacity-50 font-monospace">#<%# Container.ItemIndex + 1 %></td>
                                                    <td class="fw-bold"><a href='ManageUsers.aspx' class="text-neutral text-decoration-none hover-gold"><%# Eval("StudentName") %></a></td>
                                                    <td class="text-center"><span class="badge badge-outline-gold rounded-pill px-3 py-1"><%# Eval("QuizzesTaken") %> Taken</span></td>
                                                    <td class="text-end pe-3 fw-bold text-gold fs-6"><%# Eval("AvgScore") %>%</td>
                                                </tr>
                                            </ItemTemplate>
                                        </asp:Repeater>
                                        <asp:PlaceHolder ID="phNoStudents" runat="server" Visible="false">
                                            <tr><td colspan="4" class="text-center text-neutral opacity-50 py-5 font-classic">No student activity found yet.</td></tr>
                                        </asp:PlaceHolder>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="tab-pane fade flex-grow-1 d-flex flex-column pb-4" id="logs" role="tabpanel">
                <asp:UpdatePanel ID="upLogs" runat="server" UpdateMode="Conditional" class="d-flex flex-column flex-grow-1">
                    <ContentTemplate>
                        
                        <div class="log-container flex-grow-1 d-flex flex-column">
                            
                            <div class="d-flex justify-content-between align-items-start mb-4">
                                <div>
                                    <h4 class="fw-bold text-neutral font-classic m-0 d-flex align-items-center">
                                        <i class="bi bi-terminal text-gold me-2"></i> System Activity Logs
                                        <i class="bi bi-question-circle-fill text-gold ms-3 hint-icon" data-bs-toggle="tooltip" data-bs-placement="right" title="
                                        <div class='text-start' style='font-size: 0.8rem; line-height: 1.5; min-width: 320px;'>
                                            <b style='font-size: 0.9rem; text-transform: uppercase; letter-spacing: 1px;'>Exact Log Triggers</b><br/><br/>
    
                                            <b class='text-warning'>[ Security ]</b><br/>
                                            • <b>Brute Force Warning:</b> ≥ 3 failed login attempts<br/>
                                            • <b>Changed Password:</b> Admin updates their credentials<br/><br/>
    
                                            <b class='text-warning'>[ User Management ]</b><br/>
                                            • <b>CRUD Operations:</b> Admin creates, modifies, or deletes user accounts<br/>
                                            • <b>Profile Updates:</b> Admin changes their avatar or contact info<br/><br/>
    
                                            <b class='text-warning'>[ Content Moderation ]</b><br/>
                                            • <b>Queue Triage:</b> Admin approves, rejects, or archives content<br/><br/>

                                            <b class='text-warning'>[ Community Moderation ]</b><br/>
                                            • <b>Censorship:</b> Admin removes inappropriate user comments<br/><br/>

                                            <b class='text-warning'>[ Support ]</b><br/>
                                            • <b>Ticket Resolution:</b> Admin marks a ticket as Solved or Rejected<br/><br/>
    
                                            <b class='text-warning'>[ ContentStats ]</b><br/>
                                            • <b>Manual Summary:</b> Admin generates a statistical snapshot<br/><br/>

                                            <b class='text-warning'>[ Live Sessions & Maintenance ]</b><br/>
                                            • <b>System Events:</b> External module triggers and routine health checks
                                        </div>"></i>                                    
                                    </h4>
                                    <p class="text-neutral opacity-50 small font-sans fw-bold mt-2 mb-0">Raw JSON data reports generated by the system. Hover over the JSON column to read the full data.</p>
                                </div>
                                
                                <div class="d-flex flex-column align-items-end">
                                    <asp:LinkButton ID="btnGenerateLog" runat="server" CssClass="btn-outline-dark-custom shadow-sm" OnClick="btnGenerateLog_Click">
                                        <i class="bi bi-file-earmark-plus me-2 text-gold"></i> Generate Manual Report
                                    </asp:LinkButton>
                                </div>
                            </div>
                            
                            <div class="outlined-card p-4 mb-4 d-flex flex-nowrap align-items-end gap-3 custom-scroll" style="overflow-x: auto; white-space: nowrap;">
                                
                                <div style="flex: 1; min-width: 250px;">
                                    <span class="filter-label">Search Query</span>
                                    <asp:TextBox ID="txtLogSearch" runat="server" CssClass="form-control elegant-input w-100" placeholder="Search logs or JSON..."></asp:TextBox>
                                </div>
                                
                                <div style="flex: 1; min-width: 220px;">
                                    <span class="filter-label">Event Category</span>
                                    <asp:DropDownList ID="ddlLogType" runat="server" CssClass="form-select elegant-input w-100">
                                        <asp:ListItem Text="All Categories" Value=""></asp:ListItem>
                                        <asp:ListItem Text="Security" Value="Security"></asp:ListItem>
                                        <asp:ListItem Text="User Management" Value="User Management"></asp:ListItem>
                                        <asp:ListItem Text="Content Moderation" Value="Content Moderation"></asp:ListItem>
                                        <asp:ListItem Text="Community Moderation" Value="Community Moderation"></asp:ListItem>
                                        <asp:ListItem Text="Support" Value="Support"></asp:ListItem>
                                        <asp:ListItem Text="ContentStats" Value="ContentStats"></asp:ListItem>
                                        <asp:ListItem Text="Live Sessions" Value="Live Sessions"></asp:ListItem>
                                        <asp:ListItem Text="Maintenance" Value="Maintenance"></asp:ListItem>
                                    </asp:DropDownList>
                                </div>

                                <div style="flex: 1; min-width: 160px;">
                                    <span class="filter-label">Start Date</span>
                                    <asp:TextBox ID="txtStartDate" runat="server" TextMode="Date" CssClass="form-control elegant-input w-100"></asp:TextBox>
                                </div>

                                <div style="flex: 1; min-width: 160px;">
                                    <span class="filter-label">End Date</span>
                                    <asp:TextBox ID="txtEndDate" runat="server" TextMode="Date" CssClass="form-control elegant-input w-100"></asp:TextBox>
                                </div>

                                <div class="d-flex gap-2 ms-auto ps-2">
                                    <asp:LinkButton ID="btnClearFilters" runat="server" CssClass="btn-outline-danger-custom" style="height: 45px;" OnClick="btnClearFilters_Click" ToolTip="Reset Filters">
                                        <i class="bi bi-arrow-counterclockwise me-1"></i> Clear
                                    </asp:LinkButton>
                                    <asp:Button ID="btnApplyFilters" runat="server" Text="Apply Filters" CssClass="btn-outline-dark-custom" style="height: 45px;" OnClick="btnApplyFilters_Click" />
                                </div>
                            </div>

                            <div class="row px-4 py-2 text-neutral opacity-50 fw-bold small border-bottom mb-3 text-uppercase font-sans w-100 m-0" style="letter-spacing: 1px; border-color: var(--neutral-dark) !important;">
                                <div class="col-2" title="When the event occurred">Date</div>
                                <div class="col-3" title="Specific action taken">Report Name</div>
                                <div class="col-2" title="Category of the event">Type</div>
                                <div class="col-4" title="Raw data snippet (Hover to view all)">JSON Data (Snippet)</div>
                                <div class="col-1 text-end pe-2" title="Who triggered the event">User</div>
                            </div>

                            <div class="custom-scroll flex-grow-1 pb-3" style="max-height: 45vh; overflow-y: auto;">
                                <asp:Repeater ID="rptSystemLogs" runat="server">
                                    <ItemTemplate>
                                        <div class="row align-items-center px-4 py-3 mb-2 m-0 log-row-card shadow-sm">
                                            <div class="col-2 text-neutral opacity-75 fw-bold small"><%# Eval("GeneratedAt", "{0:MMM dd, yyyy HH:mm}") %></div>
                                            
                                            <div class="col-3 fw-bold text-neutral" style="line-height: 1.2;">
                                                <i class="bi bi-file-earmark-code text-gold me-2"></i> <%# Eval("ReportName") %>
                                            </div>
                                            
                                            <div class="col-2">
                                                <span class="badge px-3 py-1 rounded-pill <%# Eval("TypeBadgeClass") %> font-sans"><%# Eval("ReportType") %></span>
                                            </div>
                                            
                                            <div class="col-4 text-neutral opacity-50 fw-bold small text-truncate font-monospace" data-bs-toggle="tooltip" title='<%# Eval("FullJson") %>' style="cursor: help; max-width: 100%;">
                                                <%# Eval("JsonSnippet") %>
                                            </div>
                                            
                                            <div class="col-1 text-end pe-2 text-neutral fw-bold small font-sans">
                                                <i class="bi bi-person-fill text-gold me-1"></i> <%# Eval("Username") %>
                                            </div>
                                        </div>
                                    </ItemTemplate>
                                </asp:Repeater>
                                
                                <asp:PlaceHolder ID="phNoLogs" runat="server" Visible="false">
                                    <div class="text-center text-neutral opacity-50 py-5 font-classic outlined-card">
                                        <i class="bi bi-search fs-1 d-block mb-3 text-gold"></i>
                                        <h5 class="fw-bold">No system reports found matching your criteria.</h5>
                                    </div>
                                </asp:PlaceHolder>
                            </div>

                            <asp:Panel ID="pnlLogPagination" runat="server" CssClass="d-flex justify-content-between align-items-center p-4 border-top w-100 bg-white rounded-bottom-4 mt-3 outlined-card">
                                <div>
                                    <div class="text-neutral small fw-bold font-sans">
                                        Showing Page <asp:Literal ID="litLogCurrentPage" runat="server"></asp:Literal> of <asp:Literal ID="litLogTotalPages" runat="server"></asp:Literal>
                                    </div>
                                    <div class="text-neutral opacity-50 font-sans" style="font-size: 0.75rem;">
                                        (Total <asp:Literal ID="litLogTotalRecords" runat="server"></asp:Literal> logs)
                                    </div>
                                </div>
                                <div class="d-flex gap-2">
                                    <asp:LinkButton ID="btnPrevLogPage" runat="server" CssClass="btn-outline-dark-custom btn-sm px-3" OnClick="btnPrevLogPage_Click">
                                        <i class="bi bi-chevron-left me-1"></i> Prev
                                    </asp:LinkButton>
                                    <asp:LinkButton ID="btnNextLogPage" runat="server" CssClass="btn-outline-dark-custom btn-sm px-3" OnClick="btnNextLogPage_Click">
                                        Next <i class="bi bi-chevron-right ms-1"></i>
                                    </asp:LinkButton>
                                </div>
                            </asp:Panel>

                        </div>

                    </ContentTemplate>
                </asp:UpdatePanel>
            </div>

        </div>
    </div>

    <script>
        let myChart = null; 

        function renderUserChart() {
            const labelsStr = document.getElementById('hfChartLabels').value;
            const dataStr = document.getElementById('hfChartData').value;
            if (!labelsStr || !dataStr) return;

            const labels = JSON.parse(labelsStr);
            const data = JSON.parse(dataStr);

            const ctx = document.getElementById('userGrowthChart').getContext('2d');
            
            if (myChart != null) {
                myChart.destroy();
            }

            myChart = new Chart(ctx, {
                type: 'bar',
                data: {
                    labels: labels, 
                    datasets: [{
                        label: 'New Users Joined',
                        data: data,
                        backgroundColor: 'transparent',
                        borderColor: '#212529', /* Neutral Dark Outline */
                        borderWidth: 2,
                        borderRadius: 6,
                        hoverBackgroundColor: '#D4AF37', /* Imperial Gold Fill */
                        hoverBorderColor: '#D4AF37'
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false, 
                    scales: {
                        y: { 
                            beginAtZero: true, 
                            ticks: { precision: 0, font: { family: "'Segoe UI', sans-serif", weight: 'bold' }, color: '#212529' },
                            grid: { color: 'rgba(33, 37, 41, 0.1)' }
                        },
                        x: {
                            ticks: { font: { family: "'Segoe UI', sans-serif", weight: 'bold' }, color: '#212529' },
                            grid: { display: false }
                        }
                    },
                    plugins: {
                        legend: { display: false },
                        tooltip: {
                            backgroundColor: '#212529',
                            titleColor: '#D4AF37',
                            bodyColor: '#FFFFFF',
                            titleFont: { family: "'Segoe UI', sans-serif", size: 14 },
                            bodyFont: { family: "'Segoe UI', sans-serif", size: 14, weight: 'bold' },
                            padding: 12,
                            displayColors: false
                        }
                    }
                }
            });
        }

        function initializeUI() {
            var activeTabId = document.getElementById('<%= hfActiveReportTab.ClientID %>').value;
            var tabTriggerEl = document.getElementById(activeTabId + '-tab');
            if (tabTriggerEl) {
                var tab = new bootstrap.Tab(tabTriggerEl);
                tab.show();
            }

            // 🔥 ENABLE HTML TOOLTIPS FOR DETAILED HINTS
            var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
            tooltipTriggerList.map(function (tooltipTriggerEl) {
                return new bootstrap.Tooltip(tooltipTriggerEl, { html: true });
            });

            if (activeTabId === 'analytics') {
                renderUserChart();
            }
        }

        document.addEventListener("DOMContentLoaded", initializeUI);
        Sys.WebForms.PageRequestManager.getInstance().add_endRequest(initializeUI);
    </script>
</asp:Content>