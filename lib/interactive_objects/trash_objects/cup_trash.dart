import '../../enums/trash_type.dart';
import '../trash.dart';

class CupTrash extends Trash {
  CupTrash({required super.position})
    : super(trashType: TrashType.plastic, spriteSrc: 'trash_objects/cup.png');
}