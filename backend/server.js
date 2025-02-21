const express = require("express");
const cors = require("cors");
const bodyParser = require("body-parser");

const app = express();
app.use(cors());
app.use(bodyParser.json());

app.post("/submit", (req, res) => {
  const { username, password, confirmPassword } = req.body;
  if (password !== confirmPassword) {
    return res.status(400).json({ error: "Passwords do not match!" });
  }
  res.json({ message: "Form submitted successfully!" });
});

app.listen(5000, () => console.log("Server running on port 5000"));
