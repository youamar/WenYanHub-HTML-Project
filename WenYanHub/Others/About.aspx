<%@ Page Title="About Us" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="About.aspx.cs" Inherits="WenYanHub.Others.About" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    
    <style>
        /* 核心颜色升级：深褐色主题 */
        .text-brown { color: #3e2723 !important; }
        .bg-brown { background-color: #3e2723 !important; color: #fdfbf7 !important; }
        .btn-brown {
            background-color: #3e2723;
            color: #fdfbf7;
            border: none;
            transition: all 0.3s ease;
        }
        .btn-brown:hover {
            background-color: #5d4037;
            color: #fff;
            transform: translateY(-3px);
            box-shadow: 0 8px 20px rgba(93, 64, 55, 0.3);
        }

        /* 顶部大图特效 */
        .about-hero {
            background: linear-gradient(to right, rgba(62, 39, 35, 0.9), rgba(62, 39, 35, 0.7)), url('https://sfg218.com/uploads/images/1080529041456(1)(1).jpg') center/cover;
            color: #FDFBF7;
            padding: 100px 0;
            border-radius: 16px;
            margin-bottom: 60px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.15);
        }
        .section-title {
            position: relative;
            display: inline-block;
            margin-bottom: 30px;
            color: #3e2723;
        }
        .section-title::after {
            content: '';
            position: absolute;
            width: 50%;
            height: 3px;
            background-color: #8b0000; /* 保留一点点朱砂红点缀 */
            bottom: -10px;
            left: 0;
        }
        .core-feature-card {
            background: #fff;
            border-left: 4px solid #d4af37;
            transition: all 0.3s ease;
        }
        .core-feature-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 25px rgba(0,0,0,0.1) !important;
        }

        /* 基础相框样式保留高级感 */
        .team-photo {
            width: 100%;
            max-width: 180px;
            height: 240px; 
            object-fit: cover; 
            border-radius: 6px !important; 
            border: 4px solid #fff; 
            box-shadow: 0 5px 15px rgba(0,0,0,0.08); 
            background-color: #fdfbf7;
            margin-bottom: 20px;
            transition: all 0.5s cubic-bezier(0.25, 0.8, 0.25, 1);
        }

        /* 🔥 魔法核心：团队卡片的散落与觉醒特效 */
        .team-member-wrapper {
            position: relative;
            perspective: 1000px; /* 增加 3D 景深 */
        }

        .team-member {
            background: #fdfbf7;
            border: 1px solid #eaeaea;
            border-radius: 12px;
            padding: 25px 20px;
            text-align: center;
            height: 100%;
            display: flex;
            flex-direction: column;
            align-items: center;
            /* 设置动画的弹性与顺滑度 */
            transition: all 0.5s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            transform-origin: center bottom; /* 以底部为重心摆正 */
            position: relative;
            z-index: 1;
        }

        /* 让奇数位的卡片向左倾斜 -4 度 */
        .col-lg-3:nth-child(odd) .team-member {
            transform: rotate(-4deg) translateY(10px);
        }

        /* 让偶数位的卡片向右倾斜 3 度 */
        .col-lg-3:nth-child(even) .team-member {
            transform: rotate(3deg) translateY(5px);
        }

        /* 🖱️ 悬停时的“摆正 + 觉醒”特效 */
        .col-lg-3:hover .team-member {
            transform: rotate(0deg) translateY(-15px) scale(1.05); /* 瞬间摆正、放大、上浮 */
            border-color: #d4af37; /* 边框变成烫金色 */
            background: #fff;
            box-shadow: 0 20px 40px rgba(62, 39, 35, 0.2); /* 爆发出深褐色阴影 */
            z-index: 10; /* 绝对浮现在其他卡片之上 */
        }

        /* 悬停时，里面的照片也跟着互动 */
        .col-lg-3:hover .team-photo {
            border-color: #3e2723; 
            transform: scale(1.03);
            box-shadow: 0 10px 20px rgba(0,0,0,0.15);
        }
    </style>

    <div class="container mt-4 mb-5">
        
        <div class="about-hero text-center px-4">
            <h1 class="display-4 font-classic fw-bold mb-4" style="text-shadow: 0 4px 15px rgba(0,0,0,0.8);">
                Bridging Ancient Wisdom & Modern Minds
            </h1>
            <p class="lead mx-auto" style="max-width: 800px; line-height: 1.8; color: #e0dcd3;">
                In today's fast-paced world, the profound depth and spirit of ancient texts are often obscured by archaic language. WenYanHub breaks down these temporal barriers, leveraging modern Web technologies to build an immersive, bilingual, and gamified Classical Chinese learning hub tailored for Malaysian Independent High School students.
            </p>
        </div>

        <div class="row mb-5 align-items-center">
            <div class="col-lg-6 mb-4 mb-lg-0">
                <h2 class="font-classic fw-bold section-title">Our Origin Story</h2>
                <p class="text-secondary" style="line-height: 1.9; text-align: justify; font-size: 1.1rem;">
                    The epic universes found in Chinese culture—whether it's the grandeur of "a single speck of dust filling the sea" or the bold spirit of "scaling Mount Tai and looking down at the world"—should not be confined to dusty old pages.
                </p>
                <p class="text-secondary" style="line-height: 1.9; text-align: justify; font-size: 1.1rem;">
                    As explorers in the realm of computer science and cybersecurity, we are accustomed to building systems with the strictest logic. However, when cold code meets the warmth of classical literature, a fascinating chemical reaction occurs. We aim to utilize ASP.NET and robust database architectures to eliminate the three major pain points of traditional Wenyanwen learning: it being <strong>"obscure, boring, and lacking interaction"</strong>, thereby breathing new digital life into ancient texts.
                </p>
            </div>
            <div class="col-lg-5 offset-lg-1">
                <img src="https://lovecommunity.my/image/lovecom/image/cache/data/all_product_images/product-12845/XIL65tVU1726109524-440x433.jpg" class="img-fluid rounded-4 shadow-lg" alt="Ancient Text meets Technology" />
            </div>
        </div>

        <div class="mb-5">
            <h2 class="font-classic fw-bold section-title">Reinventing the Learning Experience</h2>
            <div class="row g-4 mt-2">
                <div class="col-md-4">
                    <div class="card core-feature-card h-100 p-4 border-0 shadow-sm">
                        <i class="fa-solid fa-language fa-2x mb-3 text-warning"></i>
                        <h5 class="fw-bold text-brown">Bilingual Deep Dive</h5>
                        <p class="text-muted small mb-0">Precise sentence-by-sentence bilingual alignments, supplemented with modern Chinese and English translations, seamlessly bridging the language gap.</p>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="card core-feature-card h-100 p-4 border-0 shadow-sm" style="border-left-color: #8b0000;">
                        <i class="fa-solid fa-gamepad fa-2x mb-3 text-danger"></i>
                        <h5 class="fw-bold text-brown">Gamified Challenges</h5>
                        <p class="text-muted small mb-0">Introducing Daily Quizzes and achievement systems to transform tedious memorization into a highly rewarding, game-like experience.</p>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="card core-feature-card h-100 p-4 border-0 shadow-sm" style="border-left-color: #4a6fa5;">
                        <i class="fa-solid fa-people-group fa-2x mb-3 text-primary"></i>
                        <h5 class="fw-bold text-brown">Interactive Scholar Notes</h5>
                        <p class="text-muted small mb-0">Breaking the isolation of studying. Scholars can share insights and exchange ideas in the discussion boards, building a vibrant academic community.</p>
                    </div>
                </div>
            </div>
        </div>

        <div class="mb-5 p-5 rounded-4 border shadow-sm" style="background-color: #f5f3ef;">
            <div class="text-center mb-5">
                <h2 class="font-classic fw-bold text-brown">The Creators</h2>
                <p class="text-muted">Proudly presented by students from Asia Pacific University (APU)</p>
            </div>
            <div class="row g-4 justify-content-center">
                
                <div class="col-lg-3 col-md-6 team-member-wrapper">
                    <div class="team-member shadow-sm">
                        <img src='<%= ResolveUrl("~/Image/Team/ChangKaiYang.jpeg") %>' 
                             onerror="this.src='https://ui-avatars.com/api/?name=Chang+Kai+Yang&background=3e2723&color=fff&size=256&rounded=false';" 
                             class="team-photo" alt="Chang Kai Yang" />
                        <h6 class="fw-bold text-brown mb-1">Chang Kai Yang</h6>
                        <span class="badge bg-secondary mb-2" style="letter-spacing: 1px;">TP081501</span>
                    </div>
                </div>

                <div class="col-lg-3 col-md-6 team-member-wrapper">
                    <div class="team-member shadow-sm">
                        <img src='<%= ResolveUrl("~/Image/Team/TanBiJin.jpeg") %>' 
                             onerror="this.src='https://ui-avatars.com/api/?name=Tan+Bi+Jin&background=3e2723&color=fff&size=256&rounded=false';" 
                             class="team-photo" alt="Tan Bi Jin" />
                        <h6 class="fw-bold text-brown mb-1">Tan Bi Jin</h6>
                        <span class="badge bg-secondary mb-2" style="letter-spacing: 1px;">TP081082</span>
                    </div>
                </div>

                <div class="col-lg-3 col-md-6 team-member-wrapper">
                    <div class="team-member shadow-sm">
                        <img src='<%= ResolveUrl("~/Image/Team/NicholasWongHeng.jpeg") %>' 
                             onerror="this.src='https://ui-avatars.com/api/?name=Nicholas+Wong+Heng&background=3e2723&color=fff&size=256&rounded=false';" 
                             class="team-photo" alt="Nicholas Wong Heng" />
                        <h6 class="fw-bold text-brown mb-1" style="font-size: 0.9rem;">Nicholas Wong Heng</h6>
                        <span class="badge bg-secondary mb-2" style="letter-spacing: 1px;">TP080676</span>
                    </div>
                </div>

                <div class="col-lg-3 col-md-6 team-member-wrapper">
                    <div class="team-member shadow-sm">
                        <img src='<%= ResolveUrl("~/Image/Team/GanZhiHe.jpeg") %>' 
                             onerror="this.src='https://ui-avatars.com/api/?name=Gan+Zhi+He&background=3e2723&color=fff&size=256&rounded=false';" 
                             class="team-photo" alt="Gan Zhi He" />
                        <h6 class="fw-bold text-brown mb-1">Gan Zhi He</h6>
                        <span class="badge bg-secondary mb-2" style="letter-spacing: 1px;">TP084285</span>
                    </div>
                </div>

            </div>

        <div class="text-center mt-5 pt-4 border-top">
            <h4 class="font-classic fw-bold text-brown mb-3">Journey With Us</h4>
            <p class="text-muted mb-4">Encountered an issue or have a brilliant idea to improve the platform?</p>
            <a href="Feedback.aspx" class="btn btn-brown rounded-pill px-5 py-2 shadow-sm fw-bold">
                <i class="fa-solid fa-paper-plane me-2"></i> Visit Support Center
            </a>
        </div>

    </div>

</asp:Content>