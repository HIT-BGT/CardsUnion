class ConsumersController < ApplicationController
  def show
    if current_user.user_id.nil?
      @consumer = Consumer.new(nickname: "", gender: "")
      @consumer.save(validate: false)
      current_user.update_attribute(:user_id, @consumer.id)
      @account = @consumer.account
    else
      @consumer = current_user.user
      @account = @consumer.account
    end
  end

  def edit
    @consumer = Consumer.find(params[:format])
    #prevent others to change your information
    if (current_user.user_type!="Consumer") or (current_user.user!=@consumer)
      render 'show', notice: "You can not edit other consumers' personal profile!"
    end
    @account = @consumer.account
  end

  def update
    @consumer = Consumer.find(params[:format])
    @account = @consumer.account
      if @consumer.update_attributes(params[:consumer])
        phone = params[:account][:phone]
        if phone =~ /\A\d+\Z/
          if phone.length==7 || phone.length==11
            @account.update_attribute(:phone, phone)
            redirect_to @consumer, notice: 'Information was successfully updated.' and return
          else
            @account.errors.add(:phone, 'does not seem in normal length')
          end
        else
          @account.errors.add(:phone, 'does not look like a proper phone number')
        end
      end
      render action: "edit"
  end

  # DELETE /consumers/1
  # DELETE /consumers/1.json
  def destroy
    @consumer = consumer.find(params[:id])
    @consumer.destroy

    respond_to do |format|
      format.html { redirect_to consumers_url }
      format.json { head :no_content }
    end
  end
end
