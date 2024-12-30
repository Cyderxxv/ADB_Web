import React, { useContext, useEffect, useState } from 'react';
import { useNavigate } from 'react-router-dom';
import './PlaceOrder.css';
import { StoreContext } from '../../context/StoreContext';
import axios from 'axios';

const PlaceOrder = () => {
  const { getTotalCartAmount, token, sushi_list, cartItems, url } = useContext(StoreContext);

  const [formData, setFormData] = useState({
    firstName: "",
    lastName: "",
    email: "",
    street: "",
    city: "",
    state: "",
    zipcode: "",
    country: "",
    phone: ""
  });

  const navigate = useNavigate();

  useEffect(() => {
    if (!token) {
      navigate('/cart');
    } else if (getTotalCartAmount() === 0) {
      navigate('/cart');
    }
  }, [token, getTotalCartAmount, navigate]);

  const onChangeHandler = (event) => {
    const { name, value } = event.target;
    setFormData((prevData) => ({ ...prevData, [name]: value }));
  };

  const placeOrder = async (event) => {
    event.preventDefault();
    console.log("Placing order...");

    const orderItems = sushi_list.reduce((acc, item) => {
      if (cartItems[item.id] > 0) {
        const itemInfo = { ...item, quantity: cartItems[item.id] };
        acc.push(itemInfo);
      }
      return acc;
    }, []);

    const orderData = {
      address: formData,
      items: orderItems,
      amount: getTotalCartAmount() + 2,
    };

    try {
      const response = await axios.post(`${url}/api/order/place`, orderData, {
        headers: { token },
      });

      console.log("Response from server:", response.data);
      if (response.data.success) {
        const { session_url } = response.data;
        window.location.replace(session_url);
      } else {
        alert(`Error: ${response.data.message}`);
      }
    } catch (error) {
      console.error("Error placing order:", error);
      alert("An error occurred while placing the order. Please try again.");
    }
  };

  return (
    <form onSubmit={placeOrder} className="place-order">
      <div className="place-order-left">
        <p className="title">Delivery Information</p>
        <div className="multi-fields">
          <input
            required
            name="firstName"
            onChange={onChangeHandler}
            value={formData.firstName}
            type="text"
            placeholder="First Name"
          />
          <input
            required
            name="lastName"
            onChange={onChangeHandler}
            value={formData.lastName}
            type="text"
            placeholder="Last Name"
          />
        </div>
        <input
          required
          name="street"
          onChange={onChangeHandler}
          value={formData.street}
          type="text"
          placeholder="Street"
        />
        <input
          required
          name="city"
          onChange={onChangeHandler}
          value={formData.city}
          type="text"
          placeholder="City"
        />
        <input
          required
          name="state"
          onChange={onChangeHandler}
          value={formData.state}
          type="text"
          placeholder="State"
        />
        <input
          required
          name="zipcode"
          onChange={onChangeHandler}
          value={formData.zipcode}
          type="text"
          placeholder="Zip Code"
        />
        <input
          required
          name="country"
          onChange={onChangeHandler}
          value={formData.country}
          type="text"
          placeholder="Country"
        />
        <input
          required
          name="phone"
          onChange={onChangeHandler}
          value={formData.phone}
          type="text"
          placeholder="Phone"
        />
      </div>
      <div className="place-order-right">
        <p className="title">Order Summary</p>
        <div className="order-summary">
          {sushi_list.map((item) => (
            cartItems[item.id] > 0 && (
              <div key={item.id} className="order-item">
                <img src={`/images/${item.image}`} alt={item.name} />
                <div className="item-details">
                  <p>{item.name}</p>
                  <p>{cartItems[item.id]} x ${item.price}</p>
                </div>
              </div>
            )
          ))}
        </div>
        <div className="order-total">
          <p>Total: ${getTotalCartAmount() + 2}</p>
        </div>
        <button type="submit" className="place-order-button">Place Order</button>
      </div>
    </form>
  );
};

export default PlaceOrder;