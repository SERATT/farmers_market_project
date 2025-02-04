import requests
import json

# Base URL for the API
BASE_URL = "https://farmers-market-35xe.onrender.com/farmer-market-api"

def login_farmer(username, password):
    """Login and get authentication token"""
    login_url = f"{BASE_URL}/auth/signin"
    login_data = {
        "username": username,
        "password": password
    }
    
    try:
        print(f"Sending POST request to {login_url} with data {login_data}")
        response = requests.post(login_url, json=login_data)
        response.raise_for_status()
        
        print(f"Received response: {response.status_code} - {response.text}")
        
        # Get both the token type and access token
        auth_data = response.json()
        token_type = auth_data.get('tokenType', 'Bearer')
        access_token = auth_data.get('accessToken')
        
        # Combine them into the full authorization header
        full_token = f"{token_type} {access_token}"
        print(f"Created authorization header: {full_token}")
        return full_token
    except requests.exceptions.RequestException as e:
        print(f"Login failed: {e}")
        return None

def add_product(auth_header, name, category, price, quantity):
    """Add a new product"""
    product_url = f"{BASE_URL}/farmer/product"
    headers = {
        "Authorization": auth_header,
        "Content-Type": "application/json"
    }
    
    product_data = {
        "name": name,
        "category": category,
        "price": float(price),  # Ensure price is float
        "quantity": int(quantity)  # Ensure quantity is integer
    }
    
    try:
        print(f"Sending product creation request to {product_url}")
        print(f"Headers: {headers}")
        print(f"Product data: {product_data}")
        
        response = requests.post(product_url, headers=headers, json=product_data)
        print(f"Response status: {response.status_code}")
        print(f"Response content: {response.text}")
        
        response.raise_for_status()
        print(f"Successfully added product: {name}")
        return response.json()
    except requests.exceptions.RequestException as e:
        print(f"Failed to add product {name}: {e}")
        print(f"Response content: {e.response.text if hasattr(e, 'response') else 'No response content'}")
        return None

def main():
    # Login credentials
    username = "Ilyas"
    password = "12345"
    
    # Get authentication header
    auth_header = login_farmer(username, password)
    if not auth_header:
        print("Failed to login. Exiting...")
        return
    
    # List of products to add
    products = [
        {
            "name": "White Rice",
            "category": "GRAINS",  # Using uppercase for category
            "price": 2.99,
            "quantity": 100
        },
        {
            "name": "Black Rice",
            "category": "GRAINS",
            "price": 4.99,
            "quantity": 50
        },
        {
            "name": "Yellow Rice",
            "category": "GRAINS",
            "price": 3.49,
            "quantity": 75
        }
    ]
    
    # Add each product
    for product in products:
        result = add_product(
            auth_header,
            product["name"],
            product["category"],
            product["price"],
            product["quantity"]
        )
        if result:
            print(f"Product details: {json.dumps(result, indent=2)}")
        print("-" * 50)

if __name__ == "__main__":
    main()
