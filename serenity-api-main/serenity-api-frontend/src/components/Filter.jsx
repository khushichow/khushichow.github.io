import { useEffect } from "react";
import Dropdown from "react-bootstrap/Dropdown";

function Filter(props) {
  useEffect(() => {
    if (props.activeFilter === "All") {
      props.setFiltered(props.resources);
      return;
    }
    const filtered = props.resources.filter(
      (resource) => resource.service_type === props.activeFilter
    );
    props.setFiltered(filtered);
  }, [props.activeFilter]);

  return (
    <>
      <div className="filters">
        <div className="container"></div>
        <Dropdown>
          <Dropdown.Toggle variant="success" id="dropdown-basic">
            Filter
          </Dropdown.Toggle>

          <Dropdown.Menu>
            <Dropdown.Item onClick={() => props.setActiveFilter("All")}>
              All
            </Dropdown.Item>

            {props.resources?.map((resource, i) => {
              return (
                <Dropdown.Item
                  key={i}
                  onClick={() =>
                    props.setActiveFilter(`${resource.service_type}`)
                  }
                >
                  {resource.service_type}
                </Dropdown.Item>
              );
            })}
          </Dropdown.Menu>
        </Dropdown>
      </div>
    </>
  );
}

export default Filter;
