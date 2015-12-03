class AccountController < ApplicationController
  before_filter :invoke_wwpass_patch
  unloadable 

  protected

  def invoke_wwpass_patch
    AccountControllerPatch
  end
end
