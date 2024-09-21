import express from "express";
import cors from "cors";
const app = express();

app.use(express.json());
app.use(cors());

app.post("/api/users/signup", (req, res) => {
  res.status(201).json({ msg: "OK" });
});

app.post("/api/users/login", (req, res) => {
  res
    .status(200)
    .json({ token: "secret-token", user: { id: 1, email: "user@world.free" } });
});

app.post("/api/users/logout", (req, res) => {
  res.status(200).json({ msg: "OK" });
});

app.listen(3000, () => console.log("running: 3000"));
