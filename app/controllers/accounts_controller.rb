class AccountsController < ApplicationController
  def login
    if request.post?
      if do_login
        redirect_to '/databs'
       end
    end
  end
end