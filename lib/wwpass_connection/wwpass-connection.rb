# encoding: utf-8

require 'restclient'
require 'openssl'
require 'json'
require 'base64'
require File.dirname(__FILE__) + '/wwpass-exception'

class WWPass

  def initialize(cert_file, key_file, cafile, timeout = 10, spfe_addr = 'https://spfe.wwpass.com')
    @resource = RestClient::Resource.new(
        spfe_addr,
        :ssl_client_cert  =>  OpenSSL::X509::Certificate.new(File.read(cert_file)),
        :ssl_client_key   =>  OpenSSL::PKey::RSA.new(File.read(key_file)),
        :ssl_ca_file      =>  cafile,
        :verify_ssl       =>  OpenSSL::SSL::VERIFY_PEER,
        :timeout          =>  timeout
    )
  end

  def get_name
    ticket = get_ticket('', 0)
    pos = ticket.index(':')
    if pos != nil
      ticket[0, pos]
    else
      raise WWPassException.new 'SPFE return ticket without a colon'
    end
  end

  def get_ticket(auth_type = '', ttl=120)
    make_request('GET', 'get', :params => {:ttl => ttl, :auth_type => auth_type})
  end

  def get_puid(ticket, auth_type = '')
    make_request('GET', 'puid', :params => {:ticket => ticket, :auth_type => auth_type})
  end

  def put_ticket(ticket, ttl = 120, auth_type = '')
    make_request('GET','put', :params => {:ticket => ticket, :ttl => ttl, :auth_type => auth_type})
  end

  def read_data(ticket, container = '')
    make_request('GET','read', :params => {:ticket => ticket, :container => container})
  end

  def read_data_and_lock(ticket, lock_timeout, container = '')
    make_request('GET','read', :params => {:ticket => ticket, :container => container, :lock => '1', :to => lock_timeout})
  end

  def write_data(ticket, data, container = '')
    make_request('POST','write', {:ticket => ticket, :data => data, :container => container}, 1)
  end

  def write_data_and_unlock(ticket, data, container = '')
    make_request('POST','write', {:ticket => ticket, :data => data, :container => container, :unlock => '1'}, 1)
  end

  def lock(ticket, lock_timeout, lockid)
    make_request('GET','lock',:params => {:ticket => ticket, :lockid => lockid, :to => lock_timeout})
  end

  def unlock(ticket, lockid)
    make_request('GET','unlock', :params => {:ticket => ticket, :lockid => lockid})
  end


  private

  def make_request(method, command, params = {}, attempts = 3)
    case
      when method == 'GET'
        response = JSON @resource[command + '.json'].get(params)
      when method == 'POST'
        response = JSON @resource[command + '.json'].post(params)
    end
    if response['result']
      if response['encoding'] == 'plain'
        response['data']
      else
        Base64.decode64 response['data']
      end
    else
      #exception
      if attempts > 1
        attempts = attempts - 1
        make_request(method, command, params, attempts)
      else
        raise WWPassException.new 'SPFE return error: ', response['data']
      end
    end
  end

end
