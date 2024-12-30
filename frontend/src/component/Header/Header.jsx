import React from 'react';
import './Header.css';

const Header = () => {
  return (
    <div className='header'>
      <div className="header-contents">
        <h2>Order your favourite sushi here!</h2>
        <p>Experience the finest sushi crafted with the freshest ingredients. From classic rolls to innovative creations, our sushi menu has something for every palate. Order today and indulge in a culinary delight!</p>
        <button>View Menu</button>
      </div>
    </div>
  );
};

export default Header;