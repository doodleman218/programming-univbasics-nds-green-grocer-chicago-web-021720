require 'pry'
require 'pp'


def find_item_by_name_in_collection(name, collection)
 list_index = 0
   while list_index < collection.length do
     #binding.pry
     if name == collection[list_index][:item]
       return collection[list_index]
     end
     list_index += 1
    end
end

def consolidate_cart(cart)
  # Consult README for inputs and outputs
  #
  # REMEMBER: This returns a new Array that represents the cart. Don't merely
  # change `cart` (i.e. mutate) it. It's easier to return a new thing.
  cart_array = []
  index = 0 #arguement index
    while index < cart.length do
      item = find_item_by_name_in_collection(cart[index][:item], cart_array)
        if item != nil
          item[:count] += 1
        else  
          item = {
            :item => cart[index][:item],
            :price => cart[index][:price],
            :clearance => cart[index][:clearance],
            :count => 1
            }
          cart_array << item  
        end
        index += 1
    end
  cart_array
end

def apply_coupons(cart, coupons)
  index = 0
    while index < coupons.length do
      coupon = coupons[index]
      item = find_item_by_name_in_collection(coupon[:item], cart)
      is_item_in_cart = !!item #what if this was false
      count = is_item_in_cart && item[:count] >= coupon[:num]
        if is_item_in_cart && count
           # binding.pry
          item[:count] -= coupon[:num]
          item_with_coupon = {
            :item =>"#{coupons[index][:item]} W/COUPON",
            :price => (coupon[:cost] / coupon[:num]),
            :clearance => item[:clearance],
            :count => coupon[:num]
          }
          cart << item_with_coupon
        end
    index += 1
    end
  cart
end


def apply_clearance(cart)
  index = 0
    while index < cart.length do
       if cart[index][:clearance] == true
         cart[index][:price] = cart[index][:price] - (cart[index][:price] * 0.20).round(2)
       end
    index += 1  
   end
   cart
end



def checkout(cart, coupons)
  total = 0
  new_cart = consolidate_cart(cart)
  coupon = apply_coupons(new_cart, coupons)
  final = apply_clearance(coupon)
  index = 0
    while index < final.length do
      total += (final[index][:price] * final[index][:count])
      index += 1
    end
    if total > 100
    total -= (total * 0.10)
    end
  total 
end
