# OmniAuth Windows Azure Active Directory Strategy
[![Build Status](https://travis-ci.org/KonaTeam/omniauth-azure-oauth2.svg?branch=master)](https://travis-ci.org/KonaTeam/omniauth-azure-oauth2)

This gem provides a simple way to authenticate to Windows Azure Active Directory (WAAD) over OAuth2 using OmniAuth.

One of the unique challenges of WAAD OAuth is that WAAD is multi tenant. Any given tenant can have multiple active
directories. The CLIENT-ID, REPLY-URL and keys will be unique to the tenant/AD/application combination. This gem simply
provides hooks for determining those unique values for each call.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'omniauth-azure-oauth2'
```

## Usage

First, you will need to add your site as an application in WAAD.:
[Adding, Updating, and Removing an Application](http://msdn.microsoft.com/en-us/library/azure/dn132599.aspx)

Summary:
Select your Active Directory in https://manage.windowsazure.com/<tenantid> of type 'Web Application'. Name, sign-on url,
logo are not important.  You will need the CLIENT-ID from the application configuration and you will need to generate
an expiring key (aka 'client secret').  REPLY URL is the oauth redirect uri which will be the omniauth callback path
https://example.com/users/auth/azure_oauth2/callback. The APP ID UI just needs to be unique to that tenant and identify
your site and isn't needed to configure the gem.
Permissions need Delegated Permissions to at least have "Enable sign-on and read user's profiles".

Note: Seems like the terminology is still fluid, so follow the MS guidance (buwahaha) to set this up.

The TenantInfo information can be a hash or class. It must provide client_id and client_secret.
Optionally an aad_domain_hint and aad_tenant_id. For a simple single-tenant app, this could be:

```ruby
use OmniAuth::Builder do
  provider :azure_oauth2,
    {
      aad_client_id: ENV['AZURE_CLIENT_ID'],
      aad_client_secret: ENV['AZURE_CLIENT_SECRET'],
      aad_tenant_id: ENV['AZURE_TENANT_ID']
    }
end
```

Or the alternative format for use with [devise](https://github.com/plataformatec/devise):

```ruby
config.omniauth :azure_oauth2, aad_client_id: ENV['AZURE_CLIENT_ID'],
      aad_client_secret: ENV['AZURE_CLIENT_SECRET'], aad_tenant_id: ENV['AZURE_TENANT_ID']
```

For multi-tenant apps where you don't know the tenant_id in advance, simply leave out the aad_tenant_id to use the
[common endpoint](http://msdn.microsoft.com/en-us/library/azure/dn645542.aspx).

```ruby
use OmniAuth::Builder do
  provider :azure_oauth2,
    {
      aad_client_id: ENV['AZURE_CLIENT_ID'],
      aad_client_secret: ENV['AZURE_CLIENT_SECRET']
    }
end
```

For dynamic tenant assignment, pass a class that supports those same attributes and accepts the strategy as a parameter

```ruby
class YouTenantProvider
  def initialize(strategy)
    @strategy = strategy
  end

  def aad_client_id
    tenant.aad_client_id
  end

  def aad_client_secret
    tenant.aad_client_secret
  end

  def aad_tenant_id
    tenant.aad_tanant_id
  end

  def aad_domain_hint
    tenant.aad_domain_hint
  end

  private

  def tenant
    # whatever strategy you want to figure out the right tenant from params/session
    @tenant ||= Customer.find(@strategy.session[:customer_id])
  end
end

use OmniAuth::Builder do
  provider :azure_oauth2, YourTenantProvider
end
```

## Auth Hash Schema

The following information is provided back to you for this provider:

```ruby
{
  uid: '12345',
  info: {
    name: 'some one',
    first_name: 'some',
    last_name: 'one',
    email: 'someone@example.com',
    oid: 'd5b995c4-50d8-4f54-aafa-df7aa5af859b',
    tid: 'f2485705-21c3-4455-9942-80fea68f4d2d',
    aud: '31ec3973-58aa-4bf6-8cf4-a1a5b24463e3,
    groups: '148a4e56-f482-458a-ae0d-bd5f82353e37,be2dd60f-e6b6-4883-b436-4421948e4345'
  },
  credentials: {
    token: 'thetoken',
    refresh_token: 'refresh'
  },
  extra: { raw_info: raw_api_response }
}
```
## notes

When you make a request to WAAD you must specify a resource. The gem currently assumes this is the AD identified as '00000002-0000-0000-c000-000000000000'.
This can be passed in as part of the config. It currently isn't designed to be dynamic.

```ruby
use OmniAuth::Builder do
  provider :azure_oauth2, TenantInfo, resource: 'myresource'
end
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Make your changes, add tests, run tests (`rake`)
4. Commit your changes and tests  (`git commit -am 'Added some feature'`)
5. Push to the branch (`git push origin my-new-feature`)
6. Create new Pull Request


## Misc
Run tests `bundle exec rake`
Push to rubygems `bundle exec rake release`.

