import React, { useContext } from 'react'
import './FoodDisplay.css'
import { StoreContext } from '../../context/StoreContext'
import FoodItem from '../FoodItem/FoodItem'

const FoodDisplay = ({category}) => {

    const {sushi_list} = useContext(StoreContext)

  return (
    <div className='food-display' id='food-display'>
      <h2>Top sushi near you</h2>
      <div className="food-display-list">
        {sushi_list.map((item, index)=>{
            if (category===item.category || category==="All"){
              return <FoodItem key={index} id={item.id} name={item.name} description={item.description} price={item.price} image={item.image} />
            } 
        })}
      </div>
    </div>
  )
}

export default FoodDisplay