import express from "express";
import logger from "morgan";
import cors from "cors";
const app = express();

// DATA (DUMMY DB)
const DUMMY_USER = { id: 0, email: "" };
const USER = { id: 1, email: "user@world.free" };
const TOKEN = "secret-token";
const MAGIC_TOKEN = "2MDZQR";
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
let userBasket = [];

// HELPER FUNCTIONS
const wait = (fn, ms = 1000) => setTimeout(fn, ms);
const middlewareAuthorizeUser = (req, res, next) => {
  const { auth } = req.headers;
  const token = auth.replace("bearer ", "");

  if (token === TOKEN) {
    next();
  } else {
    res.status(403).send();
  }
};

// APP-GLOBAL MIDDLEWARE
app.use(logger("tiny"));
app.use(express.json());
app.use(cors());

// API: ITEMS + BASKET

app.get("/api/users/:id/basket", middlewareAuthorizeUser, (req, res) => {
  const { id } = req.params;

  if (Number(id) === USER.id) {
    res.status(200).json(userBasket);
  } else {
    res.status(403).send();
  }
});

app.post("/api/basket/add", (req, res) => {
  const { itemId } = req.body;

  if (userBasket.find((basketItem) => basketItem.itemId === itemId)) {
    userBasket = userBasket.map((baskeItem) =>
      baskeItem.itemId === itemId
        ? { ...baskeItem, qty: baskeItem.qty + 1 }
        : baskeItem
    );
  } else {
    const correspondingItem = items.find((item) => item.id === itemId);
    const newBasketItem = {
      ...correspondingItem,
      id: userBasket.length + 1,
      qty: 1,
      createdAt: Date.now(),
    };
    userBasket = [newBasketItem, ...userBasket];
  }

  const basketItem = userBasket.find(
    (basketItem) => basketItem.itemId === itemId
  );

  res.status(201).json({ basketItem });
});

app.get("/api/items", (req, res) => {
  res.status(200).json(items);
});

// API: USER AUTH
app.post("/api/users/signup", (req, res) => {
  res.status(201).send();
});

app.post("/api/users/login", (req, res) => {
  // SHOULD send MAGIC_TOKEN to USER.email here
  res.status(200).send();
});

app.post("/api/users/logout", middlewareAuthorizeUser, (req, res) => {
  wait(() => {
    req.user = null;

    res.status(200).send();
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

app.put("/api/users/profile", middlewareAuthorizeUser, (req, res) => {
  wait(() => {
    const { email } = req.body;
    const updatedUser = { ...USER, email };

    res.status(200).json(updatedUser);
  });
});

app.listen(3000, () => console.log("running: 3000"));
