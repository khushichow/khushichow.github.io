import Button from "react-bootstrap/Button";
import Card from "react-bootstrap/Card";
import { useEffect, useState } from "react";
import Filter from "./Filter";

function APIview() {
  const [resources, setResources] = useState([]);
  const [filtered, setFiltered] = useState([]);
  const [activeFilter, setActiveFilter] = useState("All");

  useEffect(() => {
    fetchResources();
  }, []);

  const fetchResources = async () => {
    fetch("/api/resources")
      .then((res) => {
        return res.json();
      })
      .then((data) => {
        setResources(data);
        setFiltered(data);
      });
  };

  return (
    <>
      <Filter
        resources={resources}
        setFiltered={setFiltered}
        activeFilter={activeFilter}
        setActiveFilter={setActiveFilter}
      />
      {filtered?.map((resource, i) => {
        return (
          <Card key={i}>
            <Card.Body>
              <Card.Title>{resource.resource_title}</Card.Title>
              <Card.Text>{resource.description}</Card.Text>
              <Button href={resource.link}>Read More</Button>
            </Card.Body>
          </Card>
        );
      })}
    </>
  );
}

export default APIview;
