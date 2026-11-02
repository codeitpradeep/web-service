import json
import sys
import os

def parse_custom_map_string(input_str):
    if isinstance(input_str, str) and input_str.startswith('@{') and input_str.endswith('}'):
        core = input_str[2:-1]
        pairs = core.split('; ')
        map_obj = {}
        for pair in pairs:
            parts = pair.split('=', 1)
            if len(parts) == 2:
                map_obj[parts[0].strip()] = parts[1].strip()
        return map_obj
    return input_str

def fix_json_file(file_path):
    try:
        with open(file_path, 'r', encoding='utf-8-sig') as f:
            data = json.load(f)

        for item in data:
            for key, value in item.items():
                if 'porutham_details' in key and isinstance(value, list):
                    new_list = []
                    for detail in value:
                        new_list.append(parse_custom_map_string(detail))
                    item[key] = new_list
                elif 'porutham' in key and isinstance(value, dict):
                    for sub_key, sub_value in value.items():
                        value[sub_key] = parse_custom_map_string(sub_value)

        with open(file_path, 'w', encoding='utf-8') as f:
            json.dump(data, f, ensure_ascii=False, indent=4)
        
        print(f"Successfully fixed {file_path}")

    except Exception as e:
        print(f"Error processing {file_path}: {e}")

if __name__ == "__main__":
    if len(sys.argv) > 1:
        file_path = sys.argv[1]
        if os.path.exists(file_path):
            fix_json_file(file_path)
        else:
            print(f"File not found: {file_path}")
    else:
        print("Please provide a file path.")
