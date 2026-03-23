<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Game_result.aspx.cs" Inherits="WenYanHub.Learning.Game_result" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script src="https://cdn.jsdelivr.net/npm/canvas-confetti@1.6.0/dist/confetti.browser.min.js"></script>
    <style>

    * { margin: 0; padding: 0; box-sizing: border-box; }
    
    body, html {
        height: 100%;
        font-family: "STKaiti", "Microsoft YaHei", serif;
        background-color: #FFEFD5;
    }

    .result-container {
        display: flex;
        justify-content: center;
        align-items: center;
        height: 100vh;
        background-size: cover;
    }

    .result-card {
        background: #fdf5e6;
        width: 90%;
        max-width: 500px;
        padding: 50px;
        border: 10px solid #8b4513;
        border-image: linear-gradient(#8b4513, #5d2e0d) 30;
        box-shadow: 0 20px 50px rgba(0,0,0,0.5);
        text-align: center;
        position: relative;
    }

    .scroll-header h1 {
        font-size: 3rem;
        color: #8b4513;
        letter-spacing: 5px;
        margin-bottom: 5px;
    }

    .sub-title {
        font-family: sans-serif;
        font-size: 0.8rem;
        color: #a0a0a0;
        text-transform: uppercase;
        margin-bottom: 30px;
    }

    .score-section {
        margin: 40px 0;
    }

    .label {
        font-size: 1.2rem;
        color: #666;
    }

    .score-value {
    font-size: 4rem; 
    color: #c0392b; 
    font-weight: bold;
    display: block;
    margin-top: 10px;
    text-shadow: 2px 2px 0px rgba(0,0,0,0.1);
}

    .evaluation-text {
        font-size: 1.5rem;
        color: #8b4513;
        font-style: italic;
        margin-bottom: 40px;
        border-top: 1px solid #d4c4a8;
        border-bottom: 1px solid #d4c4a8;
        padding: 10px 0;
    }

    .action-buttons {
        display: flex;
        flex-direction: column;
        gap: 15px;
    }

    .btn-action {
        padding: 15px;
        border-radius: 5px;
        font-size: 1.1rem;
        font-weight: bold;
        cursor: pointer;
        transition: all 0.3s;
        border: none;
    }

    .primary {
        background: #8b4513;
        color: white;
    }

    .primary:hover { background: #5d2e0d; transform: translateY(-3px); }

    .secondary {
        background: transparent;
        color: #8b4513;
        border: 2px solid #8b4513;
    }

    .secondary:hover { background: #8b4513; color: white; }
</style>

    <script>
    window.onload = function() {
        var duration = 3 * 1000;
        var end = Date.now() + duration;

        (function frame() {
          confetti({
            particleCount: 3,
            angle: 60,
            spread: 55,
            origin: { x: 0 },
            colors: ['#8b4513', '#c0392b', '#FFD700'] 
          });
          confetti({
            particleCount: 3,
            angle: 120,
            spread: 55,
            origin: { x: 1 },
            colors: ['#8b4513', '#c0392b', '#FFD700']
          });

          if (Date.now() < end) {
            requestAnimationFrame(frame);
          }
        }());
    };
    </script>

</head>
<body>
    <form id="form1" runat="server">
        <div class="result-container">
            <div class="ink-overlay"></div>
            
            <div class="result-card">
                <div class="scroll-header">
                    <h1>Congartulation!</h1>
                    <p class="sub-title">Challenge Result</p>
                </div>

                <div class="score-section">
                    <p class="label">Final Result</p>
                    <asp:Label ID="lblFinalScore" runat="server" Text="0" CssClass="score-value"></asp:Label>
                </div>

                <div class="evaluation-text">
                    <asp:Label ID="lblEvaluation" runat="server" Text="Very Good!!"></asp:Label>
                </div>

                <div class="action-buttons">
                    <asp:Button ID="btnRetry" runat="server" Text="Challenge Again!" CssClass="btn-action primary" OnClick="btnRetry_Click" />
                    <asp:Button ID="btnLeaderboard" runat="server" Text="View Leaderboard" CssClass="btn-action secondary" OnClick="btnLeaderboard_Click" />
                    <asp:Button ID="btnBackHome" runat="server" Text="Back to HomePage" CssClass="btn-action secondary" OnClick="btnBackHome_Click" />
                </div>
            </div>
        </div>
    </form>
</body>
</html>

