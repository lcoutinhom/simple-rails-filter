# simple_filter

## Simple dynamic filter for Rails application.

### Usage

Copy simple_filter.rb to models/concerns and then add in all model that you need to use or if you are using Rails 5.x.x add it on ApplicationRecord

``` ruby
class User
  include SimpleFilter
end
```

or 

``` ruby
class ApplicationRecord
  include SimpleFilter
end

```
***
Controller:

``` ruby
def index
  @users = User.filter(filter_params)
end

private

def filter_params
  params.permit!(users: {:id, :email, :name})
end
```
***

To use with joins:

``` ruby
def index
  @users = User.joins(:products).filter(filter_params)
end

private

def filter_params
  params.permit!(users: {:id, :email, :name}, products: {:id, :name, category: []})
end
```
> The filter also accepts array 

***

To use search function:


``` ruby
def index
  @users = User.search(search_params, params[:value])
end

private

def search_params
  params.permit(:name, :description)
end
```
***

With join:

``` ruby
def index
  @users = User.joins(:product).search(search_params, params[:value])
end

private

def search_params
  params.permit('products.name', 'users.description')
end
```

***

To use filter and search:

``` ruby
def index
  @users = User.filter(filter_params).search(search_params, params[:value])
end

private

def search_params
  params.permit(:name, :description)
end

def filter_params
  params.permit!(users: {:id, :email, :name})
end
```

Thanks!
