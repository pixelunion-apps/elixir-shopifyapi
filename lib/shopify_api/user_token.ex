defmodule ShopifyAPI.UserToken do
  @derive {Jason.Encoder,
           only: [
             :code,
             :app_name,
             :shop_name,
             :token,
             :timestamp,
             :plus,
             :scope,
             :expires_in,
             :associated_user_scope,
             :associated_user,
             :associated_user_id
           ]}
  defstruct code: "",
            app_name: "",
            shop_name: "",
            token: "",
            timestamp: 0,
            plus: false,
            scope: "",
            expires_in: 0,
            associated_user_scope: "",
            associated_user: %ShopifyAPI.AssociatedUser{},
            associated_user_id: 0

  @typedoc """
      Type that represents a Shopify Online Access Mode Auth Token with

        - app_name corresponding to %ShopifyAPI.App{name: app_name}
        - shop_name corresponding to %ShopifyAPI.Shop{domain: shop_name}
  """
  @type t :: %__MODULE__{
          code: String.t(),
          app_name: String.t(),
          shop_name: String.t(),
          token: String.t(),
          timestamp: 0,
          plus: boolean(),
          scope: String.t(),
          expires_in: integer(),
          associated_user_scope: String.t(),
          associated_user: ShopifyAPI.AssociatedUser.t(),
          associated_user_id: integer()
        }
  @type ok_t :: {:ok, t()}
  @type key :: String.t()

  alias ShopifyAPI.App
  alias ShopifyAPI.AssociatedUser

  @spec create_key(t()) :: key()
  def create_key(token) when is_struct(token, __MODULE__),
    do: create_key(token.shop_name, token.app_name, token.associated_user_id)

  @spec create_key(String.t(), String.t(), integer()) :: key()
  def create_key(shop, app, associated_user_id), do: "#{shop}:#{app}:#{associated_user_id}"

  @spec new(App.t(), String.t(), map(), String.t(), String.t()) :: t()
  def new(app, myshopify_domain, associated_user, auth_code, token) do
    %__MODULE__{
      associated_user: AssociatedUser.from_auth_request(associated_user),
      associated_user_id: associated_user["id"],
      app_name: app.name,
      shop_name: myshopify_domain,
      code: auth_code,
      token: token
    }
  end
end
