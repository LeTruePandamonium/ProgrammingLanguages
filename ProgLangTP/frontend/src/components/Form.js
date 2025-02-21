import React, { useState } from "react";

const Form = () => {
  const [username, setUsername] = useState("");
  const [password, setPassword] = useState("");
  const [confirmPassword, setConfirmPassword] = useState("");
  const [formPosition, setFormPosition] = useState({ top: "50px", left: "50px" });
  const [btnPosition, setBtnPosition] = useState({ top: "0px", left: "0px" });

  const handleSubmit = async (e) => {
    e.preventDefault();
    try {
      const response = await fetch("http://localhost:5000/submit", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ username, password, confirmPassword }),
      });
      const data = await response.json();
      alert(data.message);
    } catch (error) {
      alert("Error submitting form!");
    }
  };

  const handleButtonMove = () => {
    if (!username || !password || !confirmPassword) {
      setBtnPosition({
        top: `${Math.random() * 50}px`,
        left: `${Math.random() * 50}px`,
      });
    }
  };

  return (
    <div style={{ position: "relative", margin: "auto", width: "300px", ...formPosition }}>
      <form onSubmit={handleSubmit} style={{ border: "1px solid black", padding: "20px" }}>
        <h3>Login Form</h3>
        <input
          type="text"
          placeholder="Username"
          value={username}
          onChange={(e) => setUsername(e.target.value)}
          onBlur={handleButtonMove}
        />
        <br />
        <input
          type="password"
          placeholder="Password"
          value={password}
          onChange={(e) => setPassword(e.target.value)}
          onBlur={handleButtonMove}
        />
        <br />
        <input
          type="password"
          placeholder="Confirm Password"
          value={confirmPassword}
          onChange={(e) => setConfirmPassword(e.target.value)}
          onBlur={handleButtonMove}
        />
        <br />
        <button type="submit">Submit</button>
        <button
          type="button"
          style={{ position: "relative", ...btnPosition }}
          onClick={() => alert("Load Button Clicked")}
        >
          Load
        </button>
        <button
          type="button"
          style={{ position: "relative", ...btnPosition }}
          onClick={() => alert("Save Button Clicked")}
        >
          Save
        </button>
      </form>
    </div>
  );
};

export default Form;
