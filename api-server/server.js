import express from "express";
import cors from "cors";
const app = express();

const wait = (fn, ms = 1000) => setTimeout(fn, ms);

app.use(express.json());
app.use(cors());

// API: ITEMS
let items = [
  {
    id: 1,
    name: "drop EP digital",
    price: 5.55,
    qty: 12,
    createdAt: Date.now(),
  },
  {
    id: 2,
    name: "drop LE tee #1",
    price: 5.55,
    qty: 12,
    createdAt: Date.now(),
  },
  {
    id: 3,
    name: "drop EP LE set",
    price: 5.55,
    qty: 12,
    createdAt: Date.now(),
  },
  {
    id: 4,
    name: "drop EP CD",
    price: 5.55,
    qty: 12,
    createdAt: Date.now(),
  },
  {
    id: 5,
    name: "drop LE tee #2",
    price: 19.13,
    qty: 12,
    createdAt: Date.now(),
  },
];

app.get("/api/items", (req, res) => {
  res.status(200).json(items);
});

// API: USER AUTH
const DUMMY_USER = { id: 0, email: "" };
const USER = { id: 1, email: "user@world.free" };
const TOKEN = "secret-token";
const MAGIC_TOKEN = "2MDZQR";

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

app.put("/api/users/profile", (req, res) => {
  wait(() => {
    const { auth } = req.headers;
    const token = auth.replace("bearer ", "");

    if (token === TOKEN) {
      const { email } = req.body;
      const updatedUser = { ...USER, email };

      res.status(200).json(updatedUser);
    } else {
      res.status(403).send();
    }
  });
});

app.listen(3000, () => console.log("running: 3000"));
