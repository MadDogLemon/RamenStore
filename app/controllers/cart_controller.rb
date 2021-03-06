class CartController < ApplicationController
  before_action :authenticate_user!
   
  def add
        # get the id of the product
        id = params[:id]
        
        # if the cart exists use it, or if not make a new cart.
        
        if session[:cart] then
          cart = session[:cart]
        else
          session[:cart] = {}
          cart = session[:cart]
        end  
        
        # check if ite is there and if so increment the quantity by 1
        # if the item is not there then set the quantity to be 1
        
        if cart[id] then
          cart[id] = cart[id] + 1
        else
          cart[id] = 1
        end 
    
    redirect_to :action => :index
  end
  
  def clear
    #sets session variable to nil and bring back to index
    session[:cart] = nil
    redirect_to :action => :index
  end
    
  
  def remove
    id = params[:id]
    cart = session[:cart]
    cart.delete id
    redirect_to :action => :index
  end
  
  def reduce
    id = params[:id]
    cart = session[:cart]
   cart[id] = cart[id] - 1
    
    redirect_to :action => :index
  end
  
  
  def increase
    id = params[:id]
    cart = session[:cart]
    cart[id] = cart[id] + 1
    
    redirect_to :action => :index
  end
  
  
  def index
    # pass the cart to be displayed
    
    if session[:cart] then
      @cart = session[:cart]
    else
      @cart = {}
    end
    
  end
  
  def createOrder
    
      # @orderNo = Order.find(params[:id])
        
        
      
      @user = User.find(current_user.id)

      
      @order = @user.orders.build(:order_date => DateTime.now, :status => 'Pending')
      @order.save

      
      @cart = session[:cart] || {} # Get the content of the Cart
      @cart.each do | id, quantity |
      item = Item.find_by_id(id)
      @orderitem = @order.orderitems.build(:item_id => item.id, :title => item.title, :description => item.description, :quantity => quantity, :price=> item.price)
      @orderitem.save
      end
      
      @orders = Order.last
      @orderitems = Orderitem.where(order_id: Order.last)
      session[:cart] = nil
      # session[:cart] = nil # Hidden for development so I can refresh the page
      
  end
  
end
