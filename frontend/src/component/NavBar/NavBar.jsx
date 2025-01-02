import React, { useContext, useState, useEffect } from 'react';
import { Link, useNavigate } from 'react-router-dom';
import { StoreContext } from '../../context/StoreContext';
import { assets } from '../../assets/assets';
import './NavBar.css';

const NavBar = ({ setShowLogin }) => {
    const navigate = useNavigate();
    const [menu, setMenu] = useState("home");
    const { getTotalCartAmount, token, setToken } = useContext(StoreContext);

    useEffect(() => {
        const storedToken = localStorage.getItem("token");
        if (storedToken) {
            setToken(storedToken);
        }
    }, [setToken]);

    const logout = () => {
        localStorage.removeItem("token");
        setToken("");
        navigate("/");
    };

    return (
        <div className='navbar'>
            <Link to='/'><img src={assets.logo} alt="" className="logo" /></Link>
            <ul className="navbar-menu">
                <Link to='/' onClick={() => setMenu("home")} className={menu === "home" ? "active" : ""}>Home</Link>
                <Link to='/menu' onClick={() => setMenu("menu")} className={menu === "menu" ? "active" : ""}>Menu</Link>
                <Link to='/about' onClick={() => setMenu("about")} className={menu === "about" ? "active" : ""}>About</Link>
                <Link to='/contact' onClick={() => setMenu("contact")} className={menu === "contact" ? "active" : ""}>Contact</Link>
                {token ? (
                    <div className='navbar-profile'>
                        <img src={assets.profile_icon} alt="" />
                        <ul className="nav-profile-dropdown">
                            <li onClick={() => navigate('/myorders')}><img src={assets.bag_icon} alt="" /><p>Orders</p></li>
                            <hr />
                            <li onClick={logout}><img src={assets.logout_icon} alt="" /><p>Logout</p></li>
                        </ul>
                    </div>
                ) : (
                    <button onClick={() => setShowLogin(true)}>Sign in</button>
                )}
            </ul>
        </div>
    );
};

export default NavBar;