import React, { useContext } from 'react';
import './FoodItem.css';
import { assets } from '../../assets/assets';
import { StoreContext } from '../../context/StoreContext';

const FoodItem = ({ dish_id, dish_name, price, description, image }) => {
    const { cartItems, addToCart, removeFromCart, url } = useContext(StoreContext);

    // Debugging log to check if dish_name is received correctly
    console.log('FoodItem props:', { dish_id, dish_name, price, description, image });

    return (
        <div className='food-item'>
            <div className="food-item-img-container">
                <img className='food-item-image' src={`${url}/images/${image}`} alt={dish_name} />
                {!cartItems[dish_id]
                    ? <img className='add' onClick={() => addToCart(dish_id)} src={assets.add_icon_white} alt="Add" />
                    : <div className='food-item-counter'>
                        <img onClick={() => removeFromCart(dish_id)} src={assets.remove_icon_red} alt="Remove" />
                        <p>{cartItems[dish_id]}</p>
                        <img onClick={() => addToCart(dish_id)} src={assets.add_icon_green} alt="Add" />
                    </div>
                }
            </div>
            <div className="food-item-info">
                <div className="food-item-name-rating">
                    <p>{dish_name}</p>
                    <img src={assets.rating_starts} alt="Rating" />
                </div>
                <p className="food-item-desc">{description}</p>
                <p className="food-item-price">${price}</p>
            </div>
        </div>
    );
};

export default FoodItem;