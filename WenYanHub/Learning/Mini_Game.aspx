<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Mini_Game.aspx.cs" Inherits="WenYanHub.Learning.Mini_Game" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Mini Game - Challenge</title>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script type="text/javascript">
        // Retrieve JSON challenge data from the backend
        const quizData = <%= JsonQuestions %>;
        let currentLevel = 0;
        let score = 0;

        function initChallenge() {
            if (!quizData || quizData.length === 0) {
                Swal.fire("Error", "No questions available!", "error");
                return;
            }

            // Check if all questions have been completed (5 questions)
            if (currentLevel >= quizData.length) {
                finishAndSave();
                return;
            }

            const data = quizData[currentLevel];
            document.getElementById("challengeLevel").innerText = "Challenge " + (currentLevel + 1);
            document.getElementById("questionTitle").innerText = data.q;
            document.getElementById("scoreDisplay").innerText = score;

            const container = document.getElementById("boatContainer");
            container.innerHTML = "";

            // Filter out empty options and shuffle their order
            const options = data.options.filter(o => o).sort(() => Math.random() - 0.5);

            options.forEach((opt, index) => {
                const wrapper = document.createElement("div");
                wrapper.className = "boat-wrapper";
                wrapper.style.top = (index * 20 + 5) + "%";
                wrapper.style.animationDelay = (index * 2) + "s";
                wrapper.innerHTML = `<div class="boat-body"><span class="boat-text">${opt}</span></div>`;
                wrapper.onclick = () => checkAnswer(opt, data.a);
                container.appendChild(wrapper);
            });
        }

        function checkAnswer(selected, correct) {
            document.querySelectorAll('.boat-wrapper').forEach(b => b.style.animationPlayState = 'paused');

            if (selected === correct) {
                score += 200;
                Swal.fire({
                    title: 'Correct!',
                    icon: 'success',
                    confirmButtonText: 'Next',
                    confirmButtonColor: '#8b4513'
                }).then(nextQuestion);
            } else {
                Swal.fire({
                    title: 'Wrong!',
                    html: `The correct answer is: <b style="color:#8b4513">${correct}</b>`,
                    icon: 'error',
                    confirmButtonText: 'Continue',
                    confirmButtonColor: '#8b4513'
                }).then(nextQuestion);
            }
        }

        function nextQuestion() {
            currentLevel++;
            initChallenge();
        }

        function finishAndSave() {
            const urlParams = new URLSearchParams(window.location.search);
            const cid = urlParams.get('cid');

            if (!cid) {
                Swal.fire("Error", "Missing Content ID!", "error");
                return;
            }

            window.location.href = `Game_result.aspx?cid=${cid}&finalScore=${score}`;
        }

        window.onload = initChallenge;
    </script>

    <style>
        body, html { margin: 0; padding: 0; height: 100%; overflow: hidden; font-family: "STKaiti", "KaiTi", serif; }
        .game-container { width: 100%; height: 100vh; background: url('../Image/p8.jpeg') no-repeat center center; background-size: cover; position: relative; }
        .header { display: flex; justify-content: space-between; padding: 20px 50px; color: #8b4513; text-shadow: 2px 2px 10px rgba(0,0,0,0.8); font-size: 1.8rem; }
        .scroll-container { background: #fdf5e6; width: 70%; max-width: 800px; margin: 10px auto; padding: 20px; border-radius: 60px; border: 4px solid #8b4513; text-align: center; box-shadow: 0 10px 25px rgba(0,0,0,0.5); z-index: 10; }
        .sea-stage { position: absolute; bottom: 0; width: 100%; height: 60vh; }
        .boat-wrapper { position: absolute; left: 105%; width: 150px; height: 100px; cursor: pointer; animation: boatSlide 12s linear infinite; display: flex; align-items: center; justify-content: center; }
        .boat-wrapper:hover { animation-play-state: paused; transform: scale(1.1); z-index: 100; }
        .boat-wrapper:hover .boat-body { animation: shake 0.6s infinite ease-in-out; }
        .boat-body { width: 100%; height: 100%; background: url('../Image/game_boat5.gif') no-repeat center center; background-size: contain; display: flex; align-items: center; justify-content: center; }
        .boat-text { font-size: 1.1rem; font-weight: bold; color: #fff; background: rgba(139, 69, 19, 0.8); padding: 5px 10px; border-radius: 15px; margin-top: -20px; }
        @keyframes boatSlide { from { left: 105%; } to { left: -250px; } }
        @keyframes shake { 0%, 100% { transform: rotate(0deg) translateY(0); } 25% { transform: rotate(3deg) translateY(-3px); } 75% { transform: rotate(-3deg) translateY(-1px); } }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="sm1" runat="server"></asp:ScriptManager>
        <div class="game-container">
            <div class="header">
                <div id="challengeLevel">Challenge 1</div>
                <div id="scoreBox">Score: <span id="scoreDisplay">0</span></div>
            </div>
            <div class="scroll-container">
                <h2 id="questionTitle">Loading...</h2>
            </div>
            <div class="sea-stage" id="boatContainer"></div>
        </div>
    </form>
</body>
</html>