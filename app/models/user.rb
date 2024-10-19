class User < ApplicationRecord
  # ... existing code ...

  has_many :time_lines

  # ... rest of the existing code ...
end
