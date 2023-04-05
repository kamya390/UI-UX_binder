# frozen_string_literal: true
class OrganizationsController < ApplicationController
  include Pagy::Backend
  load_and_authorize_resource

  def index
    pagy, organizations =
      pagy(Organization.accessible_by(Current.ability).ordered_by_name)
    respond_to do |format|
      format.html
      format.json do
        data =
          organizations.as_json(
            methods: %i[building? category_name link remaining_downtime]
          )
        render json: { last_page: pagy.pages, data: }
      end
    end
  end

  def show
    @booth_chairs = @organization.booth_chairs
    @tools = Tool.checked_out_by_organization(@organization).just_tools
    @shifts = @organization.shifts
    @participants = @organization.participants
    @charges = @organization.charges
  end

  # GET /organizations/new
  # GET /organizations/new.json
  def new; end

  # GET /organizations/1/edit
  def edit; end

  # POST /organizations
  # POST /organizations.json
  def create
    @organization.save
    respond_with(@organization)
  end

  # PUT /organizations/1
  # PUT /organizations/1.json
  def update
    @organization.update(organization_params)
    respond_with(@organization)
  end

  # DELETE /organizations/1
  # DELETE /organizations/1.json
  def destroy
    @organization.destroy
    respond_with(@organization)
  end

  def hardhats
    @hardhats = Tool.checked_out_by_organization(@organization).hardhats
  end

  private

  def organization_params
    params
      .require(:organization)
      .permit(:name, :short_name, :organization_category_id)
  end
end
