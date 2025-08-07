echo "Cloning repositories from the fitcore-org organization..."

repos=(
  auth-service
  user-service
  training-service
  payment-service
  ai-service
  finance-service
  analytics-consumer
  frontend
  mobile-app
  api-gateway
)

cd ..

for repo in "${repos[@]}"; do
  if [ ! -d "$repo" ]; then
    git clone https://github.com/fitcore-org/$repo.git
  else
    echo "$repo already exists, skipping..."
  fi
done
