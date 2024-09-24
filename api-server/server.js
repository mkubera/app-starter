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
let userBasket = [
  { ...items[0], itemId: items[0].id, id: 1, qty: 1, createdAt: Date.now() },
];

// HELPER FUNCTIONS
const wait = (fn, ms = 250) => setTimeout(fn, ms);
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

app.delete("/api/basket", middlewareAuthorizeUser, (req, res) => {
  userBasket = [];

  res.status(200).send();
});

app.put(
  "/api/basket/items/:id/increment",
  middlewareAuthorizeUser,
  (req, res) => {
    const { id } = req.params;

    userBasket = userBasket.map((basketItem) =>
      basketItem.id === Number(id)
        ? { ...basketItem, qty: basketItem.qty + 1 }
        : basketItem
    );

    res.status(200).json({ id: Number(id) });
  }
);

app.put(
  "/api/basket/items/:id/decrement",
  middlewareAuthorizeUser,
  (req, res) => {
    const { id } = req.params;

    console.log(userBasket);

    if (userBasket.find((basketItem) => basketItem.id === Number(id))) {
      userBasket = userBasket.map((basketItem) =>
        basketItem.id === Number(id)
          ? { ...basketItem, qty: basketItem.qty - 1 }
          : basketItem
      );
      // .filter((basketItem) => basketItem.qty > 0);
    } else {
      res.status(403).send(`BasketItem of id ${id} doesn't exist.`);
    }

    res.status(200).json({ id: Number(id) });
  }
);

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

  const dbBasketItem = userBasket.find(
    (basketItem) => basketItem.itemId === Number(itemId)
  );

  if (!!dbBasketItem) {
    // TODO: change to 200 and json {msg: "Item already in Basket."}
    res.status(400).send();
  }

  const correspondingItem = items.find((item) => item.id === Number(itemId));

  const newBasketItem = {
    ...correspondingItem,
    id: userBasket.length + 1,
    itemId: correspondingItem.id,
    qty: 1,
    createdAt: Date.now(),
  };
  userBasket = [newBasketItem, ...userBasket];

  res.status(201).json({ basketItem: newBasketItem });
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
