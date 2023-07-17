module UsersHelper
  def account_type_label(user)
    case user.account_type
    when "public_account"
      "公開アカウント"
    when "private_account"
      "非公開アカウント"
    else
      "Unknown"
    end
  end
end
