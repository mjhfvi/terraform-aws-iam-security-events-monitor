from __future__ import annotations

import json


def main():
    get_state_file = load_terraform_state_file()
    modules = get_state_file.get('resources', [])
    resources = extract_resources(modules)
    return resources


def load_terraform_state_file(file_name='terraform.tfstate.backup'):
    with open(file_name, 'r') as file:
        tfstate = json.load(file)
    return tfstate


def write_json_to_disk(data):
    with open('tfstate.json', 'w', encoding='utf-8') as f:
        json.dump(data, f, ensure_ascii=False, indent=4)


def extract_resources(modules):
    all_resources = []
    for module in modules:
        all_resources.append({
            'type': module.get('type'),
            'name': module.get('name'),
            'attributes': module.get('instances')[0].get('attributes')
        })
        for item in all_resources:
            if 'attributes' in item and 'tags_all' in item['attributes']:
                del item['attributes']['tags_all']
                del item['attributes']['tags']
                del item['attributes']['arn']
    return all_resources


def remove_empty_fields(data):
    if isinstance(data, dict):
        return {key: value for key, value in ((key, remove_empty_fields(value)) for key, value in data.items())
                if value != '' and value != 0 and value is not False and value is not None and value != [] and value != {} and value != 'null'}
    elif isinstance(data, list):
        return [remove_empty_fields(item) for item in data]
    else:
        return data


if __name__ == '__main__':
    json_file = main()
    cleaned_data = remove_empty_fields(json_file)
    # print(json.dumps(cleaned_data, indent=1))
    write_json_to_disk(cleaned_data)
