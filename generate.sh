#!/usr/bin/env bash

snake_to_pascal() {
  echo "$1" | tr '[:upper:]' '[:lower:]' | awk -F_ '{
      for (i=1; i<=NF; i++) {
        printf("%s%s", toupper(substr($i,1,1)), substr($i,2))
      }
    }'
}

mapfile -d '' files < <(find . -type f -name "*.g.dart" -print0)

for file in "${files[@]}"; do
    dir=$(dirname "$file")

    base=$(basename "$file" _state.g.dart) # user
    state_name="$(snake_to_pascal "$base")State"

    import_name=$(basename "$file" .g.dart) # user_state
  
    screen_file="$dir/${base}_screen.dart"
    view_model_file="$dir/${base}_view_model.dart"

    screen_name="$(snake_to_pascal "$base")Screen"
    view_model_name="$(snake_to_pascal "$base")ViewModel"

    if [[ -f "$screen_file" ]]; then
        echo "Skipping (already exists): $screen_file"
    else
        cat > "$screen_file" <<EOF
import 'package:flutter/material.dart';
import 'package:view_model/widget_state.dart';
import '${base}_view_model.dart';
import '$import_name.dart';

class $screen_name extends StatefulWidget {
  const $screen_name({super.key});

  @override
  State<$screen_name> createState() => _${screen_name}State();
}

class _${screen_name}State extends AbstractPageState<$screen_name, $view_model_name, $state_name> {
  _${screen_name}State() : super($view_model_name());

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
EOF

    echo "Created and wrote content: $screen_file"
        
fi

if [[ -f "$view_model_file" ]]; then
    echo "Skipping (already exists): $view_model_file"
else
    cat > "$view_model_file" <<EOF
import 'package:view_model/view_model.dart';
import '$import_name.dart';

class $view_model_name extends AbstractViewModel<$state_name> {
  $view_model_name() : super($state_name());

  @override
  void getState() {
    // TODO: Implement state fetching logic
  }
}
EOF

    echo "Created and wrote content: $view_model_file"
fi

done