import sql from "mssql";
import fs from "fs";
import config from "../config/db.js";

const addFood = async (req, res) => {
  let image_filename = `${req.file.filename}`;
  const { name, description, price, category } = req.body;

  try {
    const pool = await sql.connect(config);
    const result = await pool.request()
      .input("name", sql.NVarChar, name)
      .input("description", sql.NVarChar, description)
      .input("price", sql.Decimal(18, 2), price)
      .input("category", sql.NVarChar, category)
      .input("image", sql.NVarChar, image_filename)
      .query(`
        INSERT INTO Dish (dish_name, description, price, category, image)
        VALUES (@name, @description, @price, @category, @image)
      `);

    res.json({ success: true, message: "Food Added" });
  } catch (error) {
    console.log(error);
    res.json({ success: false, message: "Error detected" });
  }
};

// const getFoodDetail = async (req, res) => {
//   const { foodId } = req.params;
//   try {
//     const pool = await sql.connect(config);
    
//     // Get the food details
//     const foodResult = await pool.request()
//       .input('foodId', sql.Int, foodId)
//       .query('SELECT * FROM Dish WHERE dish_id = @foodId');
    
//     if (foodResult.recordset.length === 0) {
//       return res.status(404).json({ message: "Food not found" });
//     }
    
//     const food = foodResult.recordset[0];
    
//     // Get related foods
//     const relatedFoodsResult = await pool.request()
//       .input('category', sql.NVarChar, food.category)
//       .input('foodId', sql.Int, foodId)
//       .query('SELECT TOP 5 * FROM Dish WHERE category = @category AND dish_id != @foodId');
    
//     const relatedFoods = relatedFoodsResult.recordset;
    
//     res.status(200).json({
//       food,
//       relatedFoods,
//     });
//   } catch (error) {
//     console.error(error);
//     res.status(500).json({ message: error.message });
//   }
// };

const listFood = async (req, res) => {
  try {
    const pool = await sql.connect(config);
    const result = await pool.request().query("SELECT * FROM Dish");

    res.json({ success: true, data: result.recordset });
  } catch (error) {
    console.log(error);
    res.json({ success: false, message: "Error detected" });
  }
};

const removeFood = async (req, res) => {
  const { id } = req.body;

  try {
    const pool = await sql.connect(config);
    const result = await pool.request()
      .input("id", sql.Int, id)
      .query("SELECT image FROM Dish WHERE dish_id = @id");

    if (result.recordset.length > 0) {
      const image = result.recordset[0].image;
      fs.unlink(`uploads/${image}`, () => {});

      await pool.request()
        .input("id", sql.Int, id)
        .query("DELETE FROM Dish WHERE dish_id = @id");

      res.json({ success: true, message: "Food removed" });
    } else {
      res.json({ success: false, message: "Food not found" });
    }
  } catch (error) {
    console.log(error);
    res.json({ success: false, message: "Error detected" });
  }
};

export { addFood, listFood, removeFood};