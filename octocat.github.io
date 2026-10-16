<!doctype html>
<html lang="de">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Jarvis OS</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #0f172a;
            color: #f8fafc;
            margin: 0;
            padding: 40px;
            display: flex;
            flex-direction: column;
            align-items: center;
        }
        .container {
            width: 100%;
            max-width: 600px;
            background: #1e293b;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 10px 25px rgba(0,0,0,0.3);
        }
        h1 { color: #38bdf8; margin-top: 0; }
        p { color: #94a3b8; }
        .settings, .chat-box {
            margin-top: 20px;
        }
        input, textarea {
            width: 100%;
            padding: 12px;
            margin-top: 8px;
            margin-bottom: 16px;
            border-radius: 6px;
            border: 1px solid #334155;
            background: #0f172a;
            color: #fff;
            box-sizing: border-box;
        }
        button {
            background-color: #0284c7;
            color: white;
            border: none;
            padding: 12px 20px;
            border-radius: 6px;
            cursor: pointer;
            font-weight: bold;
            width: 100%;
        }
        button:hover {
            background-color: #0ea5e9;
        }
        #response {
            background: #0f172a;
            padding: 15px;
            border-radius: 6px;
            margin-top: 20px;
            border-left: 4px solid #38bdf8;
            white-space: pre-wrap;
            min-height: 40px;
        }
    </style>
</head>
<body>

    <div class="container">
        <h1>Willkommen bei Jarvis OS</h1>
        <p>Ich kann denken und dir bei Fragen helfen.</p>
        
        <!-- API-Schlüssel Einstellungen -->
        <div class="settings">
            <label for="api-key">Groq API-Schlüssel (kostenlos unter console.groq.com):</label>
            <input type="password" id="api-key" placeholder="Trage hier deinen API-Key ein...">
        </div>

        <!-- Chat-Bereich -->
        <div class="chat-box">
            <label for="user-input">Deine Nachricht an Jarvis:</label>
            <textarea id="user-input" rows="3" placeholder="Schreibe etwas..."></textarea>
            <button onclick="askJarvis()">Senden</button>
        </div>

        <!-- Antwort-Anzeige -->
        <div id="response">Jarvis ist bereit...</div>
    </div>

    <script>
        async function askJarvis() {
            const apiKey = document.getElementById('api-key').value.trim();
            const prompt = document.getElementById('user-input').value.trim();
            const responseBox = document.getElementById('response');

            if (!apiKey) {
                responseBox.innerText = "Fehler: Bitte gib zuerst deinen API-Schlüssel oben ein!";
                return;
            }

            if (!prompt) {
                responseBox.innerText = "Bitte gib eine Nachricht ein.";
                return;
            }

            responseBox.innerText = "Jarvis denkt nach...";

            try {
                // Wir nutzen hier die offene Groq API (extrem schnell und kompatibel)
                const res = await fetch('https://api.groq.com/openai/v1/chat/completions', {
                    method: 'POST',
                    headers: {
                        'Authorization': `Bearer ${apiKey}`,
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify({
                        model: 'llama-3.3-70b-versatile',
                        messages: [
                            { role: 'system', content: 'Du bist Jarvis, ein intelligentes, hilfreiches Betriebssystem.' },
                            { role: 'user', content: prompt }
                        ]
                    })
                });

                const data = await res.json();

                if (data.choices && data.choices.length > 0) {
                    responseBox.innerText = data.choices[0].message.content;
                } else if (data.error) {
                    responseBox.innerText = "API-Fehler: " + data.error.message;
                } else {
                    responseBox.innerText = "Unbekannte Antwort der KI.";
                }

            } catch (error) {
                responseBox.innerText = "Verbindungsfehler: " + error.message;
            }
        }
    </script>
</body>
</html>
