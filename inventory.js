// use inventory;

db.createCollection("products");
db.createCollection("users");
db.createCollection("orders");
db.createCollection("order_product");

// adding product
db.products.insertOne({
  product_name: "nike hoodie",
  quantity: 15,
  price: 25000.0,
  size: "medium",
  category: "clothes",
  is_available: true,
  is_shipped: true,
});

db.products.insertOne({
  product_name: "beat by dre",
  quantity: 55,
  price: 13599.99,
  size: null,
  category: "accessories",
  is_available: true,
  is_shipped: true,
});

// adding user
db.users.insertOne({
  user_name: "john doe",
  email: "johndoe@gmail.com",
  password: "azerty101",
  is_admin: false,
  phone: "081258493935",
  created_at: Date.now(),
});

db.users.insertOne({
  user_name: "jane doe",
  email: "janedoe@gmail.com",
  password: "qwerty007",
  is_admin: false,
  phone: "08023426789",
  created_at: Date.now(),
  updated_at: new Date(),
});

// adding orders

db.orders.insertOne({
  user_id: ObjectId("673a64c5e93deb34170c641b"),
  order_amount: 25000.0,
  order_status: "pending",
  order_date: new Date(),
  payment_status: "pending",
  is_delivered: false,
});

db.orders.insertOne({
  user_id: ObjectId("673a5929e93deb34170c641a"),
  order_amount: 13599.99,
  order_status: "successful",
  order_date: new Date(),
  payment_status: "successful",
  is_delivered: true,
});

db.orders.insertOne({
  user_id: ObjectId("673a5929e93deb34170c641a"),
  order_amount: 25000.0,
  order_status: "successful",
  order_date: new Date(),
  payment_status: "successful",
  is_delivered: true,
});

db.orders.insertOne({
  user_id: ObjectId("673a64c5e93deb34170c641b"),
  order_amount: 25000.0,
  order_status: "successful",
  order_date: new Date(),
  payment_status: "paid",
  is_delivered: false,
});

// cross-reference collection
db.order_product.insertOne({
  product_id: ObjectId("673a4e6ce93deb34170c6417"),
  order_id: ObjectId("673b1e16e93deb34170c641e"),
  quantity: 3,
  unit_price: 25000.0,
});

const totalOrderAmount = db.order_product
  .aggregate([
    { $match: { order_id: ObjectId("673b1e16e93deb34170c641e") } },
    {
      $lookup: {
        from: "products",
        localField: "product_id",
        foreignField: "_id",
        as: "product_details",
      },
    },
    { $unwind: "$product_details" },
    {
      $project: {
        product_id: 1,
        quantity: 1,
        unit_price: 1,
        total: { $multiply: ["$unit_price", "$quantity"] },
      },
    },
    {
      $group: {
        _id: "$order_id",
        total_order_amount: { $sum: "$total" },
      },
    },
  ])
  .toArray();

const orderAmount = totalOrderAmount[0].total_order_amount;
db.orders.updateOne(
  { _id: ObjectId("673b1e16e93deb34170c641e") },
  { $set: { order_amount: orderAmount } }
);
