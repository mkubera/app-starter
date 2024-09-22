import express from "express";
import cors from "cors";
const app = express();

const USER = { id: 1, email: "user@world.free" };

app.use(express.json());
app.use(cors());

app.post("/api/users/signup", (req, res) => {
  res.status(201).json({ msg: "OK" });
});

app.post("/api/users/login", (req, res) => {
  req.user = USER;

  res.status(200).json({ token: "secret-token", user: USER });
});

app.post("/api/users/logout", (req, res) => {
  setTimeout(() => {
    req.user = null;

    res.status(200).json({ msg: "OK" });
  }, 1000);
});

app.listen(3000, () => console.log("running: 3000"));
