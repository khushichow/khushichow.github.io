import express from "express";
import mysql from "mysql";
import dotenv from "dotenv";

dotenv.config();

function getJSON(db, query, res) {
  db.query(query, (err, data) => {
    if (err) return res.json(err);
    return res.json(data);
  });
}

const app = express();

const db = mysql.createConnection({
  host: process.env.HOST_URL,
  user: process.env.USER,
  password: process.env.PASS,
  database: process.env.DATABASE,
});

db.connect(function (err) {
  if (err) throw err;
  console.log("Connected!");
});

app.get("/api", (req, res) => {
  res.json("Welcome to the backend!");
});

app.get("/api/resources", (req, res) => {
  getJSON(db, "SELECT * FROM RESOURCES;", res);
});

app.get("/api/locations", (req, res) => {
  getJSON(db, "SELECT * FROM LOCATIONS;", res);
});

app.listen(process.env.PORT, () => {
  console.log("Welcome to the backend!");
});
