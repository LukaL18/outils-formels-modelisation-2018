extension PetriNet {

  /// Computes the marking graph of this Petri net, starting from the given marking.
  ///
  /// This method computes the marking graph of the Petri net, assuming it is bounded, and returns
  /// the root of the marking graph. If the model isunbounded, the function returns nil.
  public func computeMarkingGraph(from initialMarking: Marking<Place, Int>) -> MarkingNode<Place>? {
    // TODO: Replace or modify this code with your own implementation.
    let root = MarkingNode(marking: initialMarking)

    var created = [root]
    var unprocessed: [(MarkingNode<Place>, [MarkingNode<Place>])] = [(root, [])]

    while let (node, predecessors) = unprocessed.popLast() {
      for transition in transitions {
        guard let nextMarking = transition.fire(from: node.marking)
          else { continue }
        if let successor = created.first(where : { other in other.marking == nextMarking }) {
          node.successors[transition] = successor
        } else if predecessors.contains(where: { other in nextMarking > other.marking }) {
          return nil
        } else {
          let successor = MarkingNode(marking: nextMarking)
          created.append(successor)
          unprocessed.append((successor, predecessors + [node]))
          node.successors[transition] = successor
        }
      }
    }

    return root

    // var acc: Set = [initialMarking]
    // var a_explorer: Set = [initialMarking]
    // while a_explorer != [] {
    //     var M = a_explorer.randomElement()!
    //     var Mset: Set = [M]
    //     a_explorer = a_explorer.subtracting(Mset)
    //     for transition in self.transitions {
    //       if (self.isFireable(transition, from: M) == true) {
    //         if (acc.contains(self.fire(transition, from: M)) == false) {
    //           var Mset2: Set = [self.fire(transition, from: M)]
    //           acc = acc.union(Mset2)
    //           a_explorer = a_explorer.union(Mset2)
    //         }
    //       }
    //     }
    // }
    // let array = Array(acc)
    // let root = MarkingNode(marking: initialMarking, successors: array)

  }

  /// Computes the coverability graph of this Petri net, starting from the given marking.
  ///
  /// This method computes the coverability graph of the Petri net, and returns its root. Note that
  /// if the model's bound, the coverability graph is actually equivalent to the marking one.
  public func computeCoverabilityGraph(from initialMarking: Marking<Place, Int>)
    -> CoverabilityNode<Place>?
  {
    // TODO: Replace or modify this code with your own implementation.
    let root = CoverabilityNode(marking: extend(initialMarking))
    return root
  }

  /// Converts a regular marking into a marking with extended integers.
  private func extend(_ marking: Marking<Place, Int>) -> Marking<Place, ExtendedInt> {
    return Marking(
      uniquePlacesWithValues: marking.map({
        ($0.place, ExtendedInt.concrete($0.value))
      }))
  }

}