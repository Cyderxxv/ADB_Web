import React, { useContext } from 'react'
import './FoodDisplay.css'
import { StoreContext } from '../../context/StoreContext'
import FoodItem from '../FoodItem/FoodItem'
import { menu_list } from "../../assets/assets";

const FoodDisplay = ({category}) => {
    const {sushi_list} = useContext(StoreContext)

    return (
        <div className='food-display' id='food-display'>
            <h2>Top sushi near you</h2>
            <div className="food-display-list">
                {sushi_list.map((item, index) => {
                    if (category === item.category_id || category === "All") {
                        return (
                            <FoodItem 
                                key={index}
                                dish_id={item.dish_id}       // ✅ Changed to match API response
                                dish_name={item.dish_name}   // ✅ Changed to match API response
                                price={item.price}
                                description={item.description}
                                image={item.image}
                            />
                        )
                    }
                })}
            </div>
        </div>
    )
}

export default FoodDisplay