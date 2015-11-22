class FeesController < ApplicationController
	def create
		@card = Card.find(params[:card_id])
		@fee = @card.fees.create(fee_params)
		if @fee.fee_type
			@card.balance += @fee.amount
		else
			@card.balance -= @fee.amount
		end 
		@card.points += @fee.amount.round
		@card.save
		redirect_to card_path(@card)
	end

	private 
	def fee_params
		params.require(:fee).permit(:fee_type, :amount)
	end
end