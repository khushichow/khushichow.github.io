import requests
from bs4 import BeautifulSoup


def get_resource_info(link, counter):
    r = requests.get(link)
    soup = BeautifulSoup(r.content, "html.parser")

    section = soup.find("section", class_="camh-masthead mh-details")
    info_title = section.find("h1")
    info_description = section.find("p")

    second_section = soup.find(
        "section",
        class_="camh-structured-content bodycopy col-14 offset-1 col-lg-9 share-selection",
    )
    table = second_section.find("dl")

    headers_title = second_section.find_all("h2")
    header_paragraphs = second_section.find_all("p")

    if info_description is not None:
        print("-" * 100)
        print(info_title.text.strip())
        print(info_description.text.strip())
        print(table.text.strip())
        print(headers_title[0].text.strip())
        print(header_paragraphs[-1].text.strip())
        print("-" * 100)
        counter += 1

    return counter


def get_pages(index, result, counter):
    if index > 8:
        return counter

    for resource in result:
        resource_title = resource.find("a", class_="secondary-cta", href=True)
        try:
            counter = get_resource_info(
                f"https://camh.ca{resource_title['href']}", counter
            )

        except AttributeError:
            pass

    index += 1
    resources = get_results(index)

    return get_pages(index, resources, counter)


def get_results(index):
    r = requests.get(
        f"https://www.camh.ca/en/your-care/programs-and-services?page={index}"
    )
    soup = BeautifulSoup(r.content, "html.parser")
    result = soup.find_all("div", class_="result-card half-width no-image")

    return result


def main():
    index = 0
    counter = 0

    resources = get_results(index)

    counter = get_pages(index, resources, counter)
    print("Total is:", counter)


main()
