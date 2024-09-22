import express from "express";
import cors from "cors";
const app = express();

const DUMMY_USER = { id: 0, email: "" };
const USER = { id: 1, email: "user@world.free" };
const TOKEN = "secret-token";
const MAGIC_TOKEN = "2MDZQR";

const wait = (fn, ms = 1000) => setTimeout(fn, ms);

app.use(express.json());
app.use(cors());

app.post("/api/users/signup", (req, res) => {
  res.status(201).send();
});

app.post("/api/users/login", (req, res) => {
  // SHOULD send MAGIC_TOKEN to USER.email here
  res.status(200).send();
});

app.post("/api/users/logout", (req, res) => {
  wait(() => {
    const { auth } = req.headers;
    const token = auth.replace("bearer ", "");

    if (token === TOKEN) {
      req.user = null;

      res.status(200).send();
    } else {
      res.status(403).send();
    }
  });
});

app.post("/api/users/magic-token", (req, res) => {
  wait(() => {
    const { magicToken } = req.body;

    if (magicToken === MAGIC_TOKEN) {
      req.user = USER;

      res.status(200).json({ token: TOKEN, user: USER });
    } else {
      res.status(401).json({ token: "", user: DUMMY_USER });
    }
  });
});

app.listen(3000, () => console.log("running: 3000"));
