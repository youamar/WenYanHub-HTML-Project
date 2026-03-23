<%@ Page Title="Home" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="WenYanHub.Others._Default" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <div class="container py-4">

        <div class="p-5 mb-5 rounded-4 shadow-lg position-relative overflow-hidden text-center text-white" 
             style="background-color: #1a1513; min-height: 400px; display: flex; flex-direction: column; justify-content: center; align-items: center;">
            
            <div class="position-absolute top-0 start-0 w-100 h-100" 
                 style="background-image: linear-gradient(to bottom, rgba(44, 36, 32, 0.6), rgba(20, 15, 12, 0.9)), url('https://pic9.sucaisucai.com/12/66/12766259_2.jpg'); background-size: cover; background-position: center;">
            </div>
            
            <div class="position-absolute rounded-circle bg-warning" 
                 style="width: 300px; height: 300px; top: -100px; left: 50%; transform: translateX(-50%); filter: blur(60px); opacity: 0.15;"></div>

            <div class="position-relative z-2 animate-up">
                <div class="d-inline-block border border-warning border-opacity-50 px-4 py-2 rounded-pill mb-4" style="background-color: rgba(0,0,0,0.3);">
                    <span class="text-uppercase ls-2 small text-warning font-classic fw-bold">The Digital Classical Library</span>
                </div>

                <h1 class="display-1 fw-bold font-classic mb-3 text-shadow-strong">
                    WenYan <span style="color: #D4AF37;">Hub</span>
                </h1>
                
                <p class="lead fs-4 mb-5 font-classic mx-auto text-shadow-strong" style="max-width: 700px; line-height: 1.8; color: #FDFBF7;">
                    "Bridging the gap between ancient wisdom and modern minds."
                    <br>
                    <span class="fs-6" style="color: #cccccc;">连接古今智慧 · 传承华夏文脉</span>
                </p>

                <div class="d-flex justify-content-center gap-3">
                    <a href="About.aspx" class="btn btn-outline-light rounded-pill px-5 py-2 font-classic backdrop-blur fw-bold">
                        Our Mission
                    </a>
                    <a href="#features" class="btn btn-light rounded-pill px-5 py-2 font-classic fw-bold shadow-sm" style="color: #8B0000;">
                        Start Exploring <i class="fa-solid fa-arrow-down ms-2"></i>
                    </a>
                </div>
            </div>
        </div>

        <div id="features" class="row g-4 mb-5">
            
            <div class="col-lg-7">
                <a href="/Contents/Index.aspx" class="card border-0 h-100 rounded-4 overflow-hidden position-relative shadow-sm text-decoration-none group-hover-zoom">
                    
                    <div class="position-absolute top-0 start-0 w-100 h-100 bg-image" 
                         style="background: url('https://p0.itc.cn/images01/20230714/ab0c85068ef545cfa82f3e5029730f77.jpeg') center/cover no-repeat;">
                    </div>
                    
                    <div class="position-absolute top-0 start-0 w-100 h-100" 
                         style="background: linear-gradient(to right, rgba(48, 71, 94, 0.9), rgba(48, 71, 94, 0.4));">
                    </div>

                    <div class="card-body position-relative z-2 p-5 d-flex flex-column justify-content-center h-100 text-white">
                        <i class="fa-solid fa-book-open display-4 mb-4 opacity-75"></i>
                        <h2 class="display-5 font-classic fw-bold mb-2">The Library</h2>
                        <p class="fs-5 opacity-75 mb-4">Access hundreds of curated texts from pre-Qin to Qing Dynasty.</p>
                        <span class="btn btn-outline-light rounded-pill px-4 align-self-start font-classic">
                            Enter Pavilion
                        </span>
                    </div>
                </a>
            </div>

            <div class="col-lg-5 d-flex flex-column gap-4">
                
                <a href='<%= Session["UserId"] != null ? ResolveUrl("~/Learning/Quiz.aspx?mode=daily") : ResolveUrl("~/Account/Login.aspx") %>' 
                   class="card border-0 rounded-4 shadow-sm h-50 text-decoration-none card-hover overflow-hidden text-white"
                   style="background-color: #4A0404;"> <div class="card-body p-4 d-flex align-items-center justify-content-between position-relative">
                        <div class="position-relative z-2">
                            <h6 class="text-uppercase text-warning ls-2 small mb-2">Daily Challenge</h6>
                            <h2 class="font-classic text-white fw-bold mb-1">Daily Quiz</h2>
                            <p class="text-white-50 small mb-0">5 Questions · 3 Minutes</p>
                        </div>
                        <div class="rounded-circle bg-white bg-opacity-25 d-flex align-items-center justify-content-center" style="width: 70px; height: 70px;">
                            <i class="fa-solid fa-pen-nib fs-3 text-white"></i>
                        </div>
                    </div>
                </a>

                <a href='<%= Session["UserId"] != null ? ResolveUrl("~/Learning/PracticeSelection.aspx") : ResolveUrl("~/Account/Login.aspx") %>' 
                   class="card border-0 rounded-4 shadow-sm h-50 text-decoration-none card-hover overflow-hidden text-white"
                   style="background-color: #8C6B1F;"> <div class="card-body p-4 d-flex align-items-center justify-content-between position-relative">
                        <div class="position-relative z-2">
                            <h6 class="text-uppercase text-light ls-2 small mb-2 opacity-75">Practice</h6>
                            <h2 class="font-classic text-white fw-bold mb-1">Exercises</h2>
                            <p class="text-white-50 small mb-0">Knowledge Enhancement.</p>
                        </div>
                        <div class="rounded-circle bg-white bg-opacity-25 d-flex align-items-center justify-content-center" style="width: 70px; height: 70px;">
                            <i class="fa-solid fa-layer-group fs-3 text-white"></i>
                        </div>
                    </div>
                </a>

            </div>
        </div>

        <div class="row g-4 mb-5 text-center">
            <div class="col-12">
                <div class="py-4 border-top border-bottom border-secondary border-opacity-25 d-flex justify-content-around flex-wrap gap-4">
                    
                    <div class="animate-up delay-1">
                        <h2 class="fw-bold font-classic display-6" style="color: #3E2723;">20+</h2>
                        <span class="text-muted small text-uppercase ls-2">Classics</span>
                    </div>
                    
                    <div class="animate-up delay-2">
                        <h2 class="fw-bold font-classic display-6" style="color: #3E2723;">1.2k</h2>
                        <span class="text-muted small text-uppercase ls-2">Scholars</span>
                    </div>
                    
                    <div class="animate-up delay-3">
                        <h2 class="fw-bold font-classic display-6" style="color: #3E2723;">Daily</h2>
                        <span class="text-muted small text-uppercase ls-2">Updates</span>
                    </div>

                </div>
            </div>
        </div>

    </div>

    <style>
        /* Typography */
        .font-classic { font-family: 'Noto Serif SC', 'KaiTi', serif; }
        .ls-2 { letter-spacing: 2px; }
        .text-shadow { text-shadow: 0 4px 15px rgba(0,0,0,0.5); }
        
        /* Interactions */
        .card-hover { transition: transform 0.3s ease, box-shadow 0.3s ease; }
        .card-hover:hover { transform: translateY(-5px); box-shadow: 0 10px 20px rgba(0,0,0,0.2) !important; }

        /* Zoom Effect */
        .group-hover-zoom .bg-image { transition: transform 0.8s ease; }
        .group-hover-zoom:hover .bg-image { transform: scale(1.05); }

        /* Glassmorphism */
        .backdrop-blur { backdrop-filter: blur(5px); background-color: rgba(255,255,255,0.1); border-color: rgba(255,255,255,0.3); }
        .backdrop-blur:hover { background-color: rgba(255,255,255,0.2); }

        /* Animations */
        .animate-up { animation: fadeUp 0.8s ease-out forwards; opacity: 0; transform: translateY(20px); }
        .delay-1 { animation-delay: 0.2s; }
        .delay-2 { animation-delay: 0.4s; }
        .delay-3 { animation-delay: 0.6s; }
        @keyframes fadeUp { to { opacity: 1; transform: translateY(0); } }
        
        /* Smooth Scroll */
        html { scroll-behavior: smooth; }

        .text-shadow { text-shadow: 0 4px 15px rgba(0,0,0,0.5); }
        /* 🔥 新增这一行：专门给 Hero Section 的文字使用，阴影更重更深 */
        .text-shadow-strong { text-shadow: 0 4px 15px rgba(0,0,0,0.8), 0 0 25px rgba(0,0,0,0.6); }
    </style>

</asp:Content>