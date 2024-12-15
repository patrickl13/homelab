REPO_DIR="homelab"
BRANCH="feature/setup_containers"

# Check if the repository already exists
if [ -d "$REPO_DIR" ]; then
    echo "Repository exists. Pulling latest changes..."
    cd $REPO_DIR
    git reset --hard
    git clean -fd
    git fetch origin $BRANCH
    git checkout $BRANCH
    git pull origin $BRANCH
else
    echo "Cloning repository..."
    git clone --branch $BRANCH https://github.com/patrickl13/homelab.git $REPO_DIR
    cd $REPO_DIR
fi

# Run Terraform
# terraform init
terraform apply -auto-approve