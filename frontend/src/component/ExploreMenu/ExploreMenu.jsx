import React from 'react';
import './ExploreMenu.css';
import { menu_list } from '../../assets/assets';

const ExploreMenu = ({ category, setCategory }) => {
  return (
    <div className='explore-menu' id='explore-menu'>
      <h1>Sushi Menu</h1>
      <p className='explore-menu-text'>
        Explore our exquisite sushi menu, featuring a variety of fresh and delicious sushi rolls, sashimi, and nigiri. Crafted with the finest ingredients, our sushi is perfect for any craving. Treat yourself today!
      </p>
      <div className='explore-menu-list'>
        {menu_list.map((item, index) => {
          return (
            <div
              onClick={() => setCategory((prev) => (prev === item.menu_name ? 'All' : item.menu_name))}
              key={index}
              className='explore-menu-list-item'
            >
              <img className={category === item.menu_name ? 'active' : ''} src={item.menu_image} alt={item.menu_name} />
              <p>{item.menu_name}</p>
            </div>
          );
        })}
      </div>
      <hr />
    </div>
  );
};

export default ExploreMenu;