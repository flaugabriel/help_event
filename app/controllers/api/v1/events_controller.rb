# frozen_string_literal: true

module Api
  module V1
    class EventsController < BaseController
      include DeviseTokenAuth::Concerns::SetUserByToken

      before_action :authenticate_user!


      before_action :set_event, only: %i[show edit update destroy]

      # GET /events
      # GET /events.json
      def index
        @events = Event.where(user_id: current_user.id)
      end

      def participating
        @event_users = EventUser.where(user_id: current_user.id)
      end

      # GET /events/1
      # GET /events/1.json
      def show
        permit_show
        data_array_event_item = []
        data = []
        @event_items = Event.new.select_item_by_events(params[:id])
        @items = Event.new.get_item_not_inclued(params[:id], current_user)
        @event_items.each do |event_item|
          print event_item.item.inspect
          data = {
            id: event_item.id,
            description: event_item.item.description,
            user: event_item.item.user.name,
            value: event_item.item.value,
            item_id: event_item.item.id,
            location: event_item.item.location,
            status: event_item.status
          }
        data_array_event_item << data
        end
        render json: { event_items: data_array_event_item, items: @items }
      end

      # GET /events/new
      def new
        @event = Event.new
      end

      # GET /events/1/edit
      def edit; end

      # POST /events
      # POST /events.json
      def create
        @event = Event.new(event_params.merge(user_id: current_user.id))
        if @event.save
          Event.new.event_create
          render json: { status: 200 }
        else
          render json: { status: @event.errors.full_messagers.to_sentence }
        end
      end

      # PATCH/PUT /events/1
      # PATCH/PUT /events/1.json
      def update
        respond_to do |format|
          if @event.update(event_params)
            format.html { redirect_to @event, notice: 'Event was successfully updated.' }
            format.json { render :show, status: :ok, location: @event }
          else
            format.html { render :edit }
            format.json { render json: @event.errors, status: :unprocessable_entity }
          end
        end
      end

      # DELETE /events/1
      # DELETE /events/1.json
      def destroy
        Event.new.delete_event(params[:id])
        @event.destroy
        flash[:error] = 'Evento removido'
        redirect_to root_path
      end

      def permit_show
        return if Event.where(id: set_event.id, user_id: current_user).present?

        flash[:error] = 'Não altorizado!'
        redirect_to root_path
      end

      private

      # Use callbacks to share common setup or constraints between actions.
      def set_event
        @event = Event.find(params[:id])
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def event_params
        params.permit(:description, :user_id, :data_event)
      end
    end
  end
end
