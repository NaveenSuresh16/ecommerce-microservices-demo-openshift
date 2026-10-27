#chmod 750 
#./mirror-images.sh

#!/usr/bin/env bash
set -euo pipefail

QUAY_HOST="quay-vhrqx.apps.cluster-vhrqx.vhrqx.sandbox5291.opentlc.com"
QUAY_NAMESPACE="boutique-lab"
AUTHFILE="/root/.config/containers/auth.json"
IMAGE_FILE="images.txt"

while IFS= read -r source_image || [[ -n "$source_image" ]]; do
    [[ -z "$source_image" || "$source_image" == \#* ]] && continue

    image_name="${source_image##*/}"
    destination_image="${QUAY_HOST}/${QUAY_NAMESPACE}/${image_name}"

    echo "Copying ${source_image} -> ${destination_image}"

    skopeo copy --all \
      --authfile "$AUTHFILE" \
      "docker://${source_image}" \
      "docker://${destination_image}"

    echo "Successfully copied ${destination_image}"
done < "$IMAGE_FILE"

echo "All images copied successfully."
