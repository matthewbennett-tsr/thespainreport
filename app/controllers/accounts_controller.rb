class AccountsController < ApplicationController
before_action :set_account, only: [:show, :edit, :update, :destroy]

# GET /accounts
# GET /accounts.json
def index
	if current_user.nil? 
		redirect_to root_url
	elsif current_user.role == 'editor'
		@accounts = Account.all
	else
		redirect_to root_url
	end
end

# GET /accounts/1
# GET /accounts/1.json
def show
	if current_user.nil? 
		redirect_to root_url
	elsif current_user.role == 'editor'
		
	else
		redirect_to root_url
	end
end

# GET /accounts/new
def new
	if current_user.nil? 
		redirect_to root_url
	elsif current_user.role == 'editor'
		@account = Account.new
	else
		redirect_to root_url
	end
end

# GET /accounts/1/edit
def edit
	if current_user.nil? 
		redirect_to root_url
	elsif current_user.role == 'editor'
		
	else
		redirect_to root_url
	end
end

# POST /accounts
# POST /accounts.json
def create
	if current_user.nil? 
		redirect_to root_url
	elsif current_user.role == 'editor'
		@account = Account.new(account_params)
		respond_to do |format|
			if @account.save
				format.html { redirect_to @account, notice: 'Account was successfully created.' }
				format.json { render :show, status: :created, location: @account }
			else
				format.html { render :new }
				format.json { render json: @account.errors, status: :unprocessable_entity }
			end
		end
	else
		redirect_to root_url
	end
end

# PATCH/PUT /accounts/1
# PATCH/PUT /accounts/1.json
def update
	if current_user.nil? 
		redirect_to root_url
	elsif current_user.role == 'editor'
		respond_to do |format|
			if @account.update(account_params)
				format.html { redirect_to @account, notice: 'Account was successfully updated.' }
				format.json { render :show, status: :ok, location: @account }
			else
				format.html { render :edit }
				format.json { render json: @account.errors, status: :unprocessable_entity }
			end
		end
	else
		redirect_to root_url
	end
end

# DELETE /accounts/1
# DELETE /accounts/1.json
def destroy
	if current_user.nil? 
		redirect_to root_url
	elsif current_user.role == 'editor'
		@account.destroy
		respond_to do |format|
		format.html { redirect_to accounts_url, notice: 'Account was successfully destroyed.' }
		format.json { head :no_content }
	end
	else
		redirect_to root_url
	end
end

private
	# Use callbacks to share common setup or constraints between actions.
	def set_account
		@account = Account.find(params[:id])
	end

	# Never trust parameters from the scary internet, only allow the white list through.
	def account_params
		params.require(:account).permit(:name)
	end
end
