class AccountController < ApplicationController
  before_filter :invoke_wwpass_patch, :require_login
  unloadable 

  protected

  def invoke_wwpass_patch
    AccountControllerPatch
  end
end
