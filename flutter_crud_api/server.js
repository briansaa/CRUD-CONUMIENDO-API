const express = require('express');
const bodyParser = require('body-parser');
const mongoose = require('mongoose');
const cors = require('cors');

const app = express();
const port = 3000;

app.use(bodyParser.json());
app.use(cors());

// Conectar a MongoDB
mongoose.connect('mongodb://192.168.56.1:27017/itemsdb', {
  useNewUrlParser: true,
  useUnifiedTopology: true,
});

const itemSchema = new mongoose.Schema({
  name: { type: String, required: true },
  quantity: { type: Number, required: true },
  available: { type: Boolean, required: true },
  addedDate: { type: Date, required: true },
});

const Item = mongoose.model('Item', itemSchema);

// Rutas CRUD
app.get('/items', async (req, res) => {
  try {
    const items = await Item.find();
    res.json(items);
  } catch (err) {
    res.status(500).send(err);
  }
});

app.post('/items', async (req, res) => {
    try {
      const { name, quantity, available, addedDate } = req.body;
      const newItem = new Item({
        name,
        quantity,
        available,
        addedDate: new Date(addedDate), 
      });
      await newItem.save();
      res.status(201).json(newItem);
    } catch (err) {
      res.status(400).send(err);
    }
  });
  

app.put('/items/:id', async (req, res) => {
  try {
    const { id } = req.params;
    const updatedItem = await Item.findByIdAndUpdate(id, req.body, { new: true });
    res.json(updatedItem);
  } catch (err) {
    res.status(400).send(err);
  }
});

app.delete('/items/:id', async (req, res) => {
  try {
    const { id } = req.params;
    await Item.findByIdAndDelete(id);
    res.status(204).end();
  } catch (err) {
    res.status(400).send(err);
  }
});

app.listen(port, () => {
  console.log(`Server running at http://localhost:${port}`);
});
