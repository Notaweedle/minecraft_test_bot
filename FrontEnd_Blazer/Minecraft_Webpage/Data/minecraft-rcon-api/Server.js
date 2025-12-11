const express = require("express");
const cors = require("cors");
const { Rcon } = require("rcon-client");

const app = express();
app.use(cors());
app.use(express.json());

// simple whitelist to stop absolute chaos
;

function validateCommand(cmd) {
    if (!cmd) return { ok: false, error: "Missing command" };

    if (!cmd.startsWith("/")) {
        return { ok: false, error: "Command must start with '/'" };
    }

    const base = cmd.split(" ")[0];


    // basic structural checks (you can go wild here)
    if (base === "/give") {
        const parts = cmd.split(" ");
        if (parts.length < 3) {
            return { ok: false, error: "/give needs a target and an item" };
        }
    }

    return { ok: true };
}

// API: validate command without running it
app.post("/validate", (req, res) => {
    const { command } = req.body;
    const validation = validateCommand(command);
    res.json(validation);
});

// API: execute (still validated)
app.post("/rcon", async (req, res) => {
    const { command } = req.body;

    const validation = validateCommand(command);
    if (!validation.ok) {
        return res.status(400).json(validation);
    }

    try {
        const rcon = new Rcon({
            host: "localhost",
            port: 25575,
            password: "Chesseburger123"
        });

        await rcon.connect();
        const result = await rcon.send(command);
        await rcon.end();

        res.json({ ok: true, result });
    } catch (err) {
        res.status(500).json({ ok: false, error: err.toString() });
    }
});

app.listen(3000, () => {
    console.log("API online at port 3000");
});
