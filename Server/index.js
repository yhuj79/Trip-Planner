const fs = require("fs");
const express = require("express");
const bodyParser = require("body-parser");
const cors = require("cors");
const mysql = require("mysql");

const app = express();
const port = process.env.PORT || 5500;

app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));
app.use(
  cors({
    origin: "*",
    methods: ["GET", "POST"],
    credentials: true,
  })
);

const data = fs.readFileSync("./database.json");
const conf = JSON.parse(data);

const connection = mysql.createConnection({
  host: conf.host,
  user: conf.user,
  password: conf.password,
  port: conf.port,
  database: conf.database,
});
connection.connect();

app.get("/api/package", (req, res) => {
  connection.query(
    "SELECT * FROM TripPlanner.package ORDER BY RAND()",
    (err, rows, fields) => {
      res.send({ results: rows });
    }
  );
});

app.get("/api/package/wish", (req, res) => {
  connection.query(
    "SELECT * FROM TripPlanner.package WHERE wish = 1",
    (err, rows, fields) => {
      res.send({ results: rows });
    }
  );
});

app.get("/api/tourist_spot", (req, res) => {
  connection.query(
    "SELECT * FROM TripPlanner.tourist_spot ORDER BY RAND()",
    (err, rows, fields) => {
      res.send({ results: rows });
    }
  );
});

app.get("/api/tourist_spot/wish", (req, res) => {
  connection.query(
    "SELECT * FROM TripPlanner.tourist_spot WHERE wish = 1",
    (err, rows, fields) => {
      res.send({ results: rows });
    }
  );
});

app.listen(port, () => console.log(`Listening on port ${port}`));
