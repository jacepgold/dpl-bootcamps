require 'rails_helper'

RSpec.describe Api::BootcampsController, type: :controller do

  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end

    it 'returns the correct JSON for all bootcamps' do
      bootcamp_count = 10
      FactoryBot.create_list(:bootcamp, bootcamp_count)
      get :index
      parsed = JSON.parse(response.body)
      expect(parsed.count).to eq(bootcamp_count)
    end
  end

  describe "GET #show" do
    before(:each) do
      @bootcamp = FactoryBot.create(:bootcamp)
      get :show, params: { id: @bootcamp.id }
    end

    it "returns http success" do
      expect(response).to have_http_status(:success)
    end

    it 'returns the right bootcamp JSON' do
      parsed = JSON.parse(response.body)
      expect(parsed['id']).to eq(@bootcamp.id)
    end
  end

  describe "POST #create" do
    context 'with valid params' do
      bootcamp_name = 'DevPoint Labs'

      let(:valid_params) { 
        { "bootcamp" => 
          { 
            "name" => bootcamp_name, 
            "year_founded" => 2003, 
            "full_time_tuition_cost" => 10000, 
            "part_time_tuition_cost" => 7000 
          }
        } 
      }

      before(:each) do
        post :create, params: valid_params
      end

      it "returns http success" do
        expect(response).to have_http_status(:success)
      end

      it 'returns the created bootcamps JSON' do
        parsed = JSON.parse(response.body)
        expect(parsed['name']).to eq(bootcamp_name)
      end
    end

    context 'with invalid params' do
      let(:invalid_params) {
        { "bootcamp" => 
          {
            "year_founded" => 2003, 
            "full_time_tuition_cost" => 10000, 
            "part_time_tuition_cost" => 7000 
          }
        } 
      }

      it 'fails to create with invalid params' do
        post :create, params: invalid_params
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['errors']).to eq("Name can't be blank")
        expect(Bootcamp.count).to eq(0)
      end
    end
  end

  context 'as a logged in user' do
    login_user

    before(:each) do
      @bootcamp = FactoryBot.create(:bootcamp)
    end

    describe "PUT #add_application" do
      it 'adds the bootcamp id to the users jsonb column' do
        expect(@user.application_ids.length).to eq(0)
        put :add_application, params: { id: @bootcamp.id }
        parsed = JSON.parse(response.body)
        expect(parsed['application_ids'].first).to eq(@bootcamp.id)
      end
    end

    describe "PUT #remove_application" do
      it 'removes the bootcamp id from the users jsonb column' do
        @user.application_ids << @bootcamp.id
        @user.save
        put :remove_application, params: { id: @bootcamp.id }
        parsed = JSON.parse(response.body)
        expect(parsed['application_ids'].length).to eq(0)
      end
    end
  end

  describe "PUT #update" do
    before(:each) do
      @bootcamp = FactoryBot.create(:bootcamp)
    end

    context 'with valid params' do
      let(:valid_params) { { name: 'Iron Yard' } }

      it "returns http success" do
        put :update, params: { id: @bootcamp.id, bootcamp: valid_params }
        expect(response).to have_http_status(:success)
      end

      it 'successfully updates the bootcamp' do
        put :update, params: { id: @bootcamp.id, bootcamp: valid_params }
        parsed = JSON.parse(response.body)
        expect(parsed['name']).to eq(valid_params[:name])
      end
    end

    context 'with invalid params' do
      it 'fails to update bootcamp' do
        put :update, params: { id: @bootcamp.id, bootcamp: { name: '' } }
        parsed = JSON.parse(response.body)
        expect(response).to have_http_status(:unprocessable_entity)
        expect(parsed['errors']).to eq("Name can't be blank")
        @bootcamp.reload
        expect(@bootcamp.name).to_not eq('')
      end
    end
  end

  describe "DELETE #destroy" do
    it "successfully deletes a bootcamp" do
      bootcamp = FactoryBot.create(:bootcamp)
      expect(Bootcamp.count).to eq(1)
      delete :destroy, params: { id: bootcamp.id }
      expect(response).to have_http_status(:success)
      expect(Bootcamp.count).to eq(0)
    end
  end

end
